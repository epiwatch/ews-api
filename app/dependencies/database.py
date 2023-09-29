from functools import lru_cache

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from app.dependencies.settings import EpiwatchSettings


# Load .env file -- prepare this way so we can use annotate later
# https://fastapi.tiangolo.com/advanced/settings/
@lru_cache()
def get_settings():
    return EpiwatchSettings()


settings = get_settings()
connectionString = f"postgresql://{settings.PSQL_USERNAME}:{settings.PSQL_PASSWORD}@{settings.PSQL_SERVER}:{settings.PSQL_PORT}/{settings.PSQL_DB}"
print(connectionString)

engine = create_engine(connectionString, pool_pre_ping=True, pool_size=10, max_overflow=20)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


