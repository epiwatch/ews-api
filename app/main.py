from contextlib import asynccontextmanager
from functools import lru_cache

from fastapi import Depends, FastAPI, Request, Response, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import URL, create_engine
from sqlalchemy.orm import sessionmaker

from app.dependencies.logger import get_logger
from app.dependencies.settings import EpiwatchSettings
from app.docs import VERSION, description
from app.v2.endpoints import datasets as v2_datasets
from app.v2.endpoints import map as v2_map
from app.v2.endpoints import static as v2_static
from app.v2.endpoints import stats as v2_stats

logger = get_logger("api")
logger.info("[API] Starting EPIWATCH API")
securitylogger = get_logger("apiasecurity")
securitylogger.info("[SECURITY] Starting EPIWATCH API")


@lru_cache()
def load_settings():
    return EpiwatchSettings()


settings = load_settings()


def get_settings(request: Request):
    try:
        request.state.settings = settings
        yield
    except Exception as e:
        logger.debug("DB error: " + str(e))


logger.debug("Loaded settings: " + str(dir(settings)))

databaseEngine = {}

@asynccontextmanager
async def dbEngine(app: FastAPI):
    try:
        database_url = URL.create(
            "postgresql",
            username=settings.PSQL_USERNAME,
            password=settings.PSQL_PASSWORD,
            host=settings.PSQL_SERVER,
            database=settings.PSQL_DB,
        )
        dbengine = create_engine(database_url, pool_pre_ping=True, pool_size=10, max_overflow=20)
        logger.debug("Adding sessionmaker to databaseEngine dictionary")
        databaseEngine["sessionmaker"] = sessionmaker(autocommit=False, autoflush=False, bind=dbengine)
        logger.debug("Yielding databaseEngine")
        yield
        logger.debug("Return from Yielding databaseEngine")
    finally:
        dbengine.dispose()
    logger.debug("Cleanup database engine")


def get_db(request: Request):
    try:
        logger.debug("Creating sessionmaker...")
        request.state.sessionmaker = databaseEngine["sessionmaker"]
        yield
    except Exception as e:
        logger.debug("DB error: " + str(e))


logger.info("Loaded settings: " + str(dir(settings)))


app = FastAPI(
    title="EPIWATCH API",
    description=description,
    version=VERSION,
    lifespan=dbEngine,
    swagger_ui_parameters={"docExpansion": "none"},
)

logger.info("Initialising cors settings, expecting: ")
logger.info(settings.WEBSITE_CORS_ALLOWED_ORIGINS)
origins = settings.WEBSITE_CORS_ALLOWED_ORIGINS.split(",")
logger.info("Origins: " + str(origins))
for origin in origins:
    logger.info("Origin: " + str(origin))
if settings.WEBSITE_CORS_ALLOWED_ORIGINS:
    app.add_middleware(
        CORSMiddleware,
        allow_origins=origins,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
        max_age=15,
    )

# ==========================TEST SERVER CONNECTION==========================
@app.get("/api/v2/healthz", status_code=status.HTTP_200_OK)
async def test_api_connection(response: Response):
    response.status_code = status.HTTP_200_OK
    return {"STATUS": response.status_code}

logger.info("Loading static router")
app.include_router(v2_static.router, prefix="/api/v2",dependencies=[Depends(get_settings), Depends(get_db)])
logger.info("Loading stats router")
app.include_router(v2_stats.router, prefix="/api/v2", dependencies=[Depends(get_settings), Depends(get_db)])
logger.info("Loading datasets router")
app.include_router(v2_datasets.router, prefix="/api/v2", dependencies=[Depends(get_settings), Depends(get_db)])
logger.info("Loading map router")
app.include_router(v2_map.router, prefix="/api/v2", dependencies=[Depends(get_settings), Depends(get_db)])
logger.info("init fastapi object")
logger.info("API ready")
