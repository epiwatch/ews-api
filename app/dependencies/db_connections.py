from sqlalchemy import URL, create_engine
from sqlalchemy.orm import sessionmaker

from app.dependencies.settings import DB_READ_ACCESS, DB_WRITE_ACCESS


def get_write_access_db_cred():
    write_settings = DB_WRITE_ACCESS()
    database_url = URL.create(
        "postgresql", username=write_settings.PSQL_USERNAME_WRITE, password=write_settings.PSQL_PASSWORD_WRITE, host=write_settings.PSQL_SERVER, database=write_settings.PSQL_DB
    )
    engine = create_engine(database_url)
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    return SessionLocal


def write_access_db():
    local_session = get_write_access_db_cred()
    db = local_session()
    try:
        yield db
    finally:
        db.close()


def db_read_access_cred():
    read_settings = DB_READ_ACCESS()
    database_url = URL.create(
        "postgresql", username=read_settings.PSQL_USERNAME_READ, password=read_settings.PSQL_PASSWORD_READ, host=read_settings.PSQL_SERVER, database=read_settings.PSQL_DB
    )
    engine = create_engine(database_url)
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    return SessionLocal


def db_read_access():
    local_session = db_read_access_cred()
    db = local_session()
    try:
        yield db
    finally:
        db.close()
