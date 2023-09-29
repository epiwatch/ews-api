from contextlib import asynccontextmanager
from functools import lru_cache

from fastapi import Depends, FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import URL, create_engine
from sqlalchemy.orm import sessionmaker

from app.dependencies.logger import get_logger
from app.dependencies.settings import EpiwatchSettings
from app.docs import VERSION, description
from app.v2.endpoints import static as v2_static

logger = get_logger("api")
logger.info("[API] Starting EPIWATCH API")

securitylogger = get_logger("apiasecurity")
securitylogger.info("[SECURITY] Starting EPIWATCH API")


# The function to load the settings from file
@lru_cache()
def load_settings():
    return EpiwatchSettings()


# store the settings
settings = load_settings()


# follows the standard injection patterns
# https://fastapi.tiangolo.com/tutorial/sql-databases/#create-a-dependency
def get_settings(request: Request):
    try:
        request.state.settings = settings
        yield
    except Exception as e:
        logger.debug("DB error: " + str(e))


# Used to store the database engine/sessionmaker
databaseEngine = {}


@asynccontextmanager
async def dbEngine(app: FastAPI):
    # Load the databaseConnectionPool
    try:
        database_url = URL.create(
            "postgresql",
            username=settings.PSQL_USERNAME,
            password=settings.PSQL_PASSWORD,  # plain (unescaped) text
            host=settings.PSQL_SERVER,
            database=settings.PSQL_DB,
        )
        logger.info("Connecting to database URL: " + str(database_url))
        dbengine = create_engine(database_url, pool_pre_ping=True, pool_size=10, max_overflow=20)
        logger.debug("Adding sessionmaker to databaseEngine dictionary")
        databaseEngine["sessionmaker"] = sessionmaker(autocommit=False, autoflush=False, bind=dbengine)
        logger.debug("Yielding databaseEngine")
        yield
        logger.debug("Return from Yielding databaseEngine")
    finally:
        dbengine.dispose()
    logger.debug("Cleanup database engine")


# Dependency
#  it follows the standard injection patterns
# https://fastapi.tiangolo.com/tutorial/sql-databases/#create-a-dependency
def get_db(request: Request):
    try:
        logger.debug("Creating sessionmaker...")
        request.state.sessionmaker = databaseEngine["sessionmaker"]
        yield
    except Exception as e:
        logger.debug("DB error: " + str(e))


# Create a FastAPI app
app = FastAPI(
    title="EPIWATCH API",
    description=description,
    version=VERSION,
    lifespan=dbEngine,
    terms_of_service="https://example.com/terms/",
)

logger.info("Initialising cors settings, expecting: ")
logger.info(settings.WEBSITE_CORS_ALLOWED_ORIGINS)
# split string into list on comma
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


logger.info("Loading static router")
app.include_router(v2_static.router, dependencies=[Depends(get_settings), Depends(get_db)], prefix="/api/v2", tags=["v2"])

logger.info("init fastapi object")
logger.info("API ready")
