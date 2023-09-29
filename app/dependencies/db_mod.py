import os

from dotenv import load_dotenv
from sqlalchemy import create_engine, text

from app.dependencies.logger import get_logger

logger = get_logger("api")


class DatabaseFactory:
    def __init__(self) -> None:
        pass

    def assign_connection(self):
        load_dotenv()
        # for local
        try:
            logger.info("Using environment variables")
            server = os.environ.get("PSQL_SERVER")
            logger.info(f"SERVER: {server}")
            port = os.environ.get("PSQL_PORT")
            logger.info(f"PORT: {port}")
            db = os.environ.get("PSQL_DB")
            logger.info(f"DB: {db}")
            username = os.environ.get("PSQL_USERNAME")
            logger.info(f"USER: {username}")
            password = os.environ.get("PSQL_PASSWORD")
            self.dbConnectionStr = f"postgresql://{username}:{password}@{server}:{port}/{db}"
            # logger.info(f"dbConnectionStr: {self.dbConnectionStr}")

        except Exception as ex:
            logger.error(f"ERROR: init_local_session - {ex}")

    def create_db(self):
        db = Database(self.dbConnectionStr)
        return db


class Database:
    def __init__(self, cursession) -> None:
        self.session = cursession

    def process_results(self, query):
        query = text(query)
        result = self.session.execute(query)
        processed = [dict(zip(result.keys(), row)) for row in result.fetchall()]
        return processed

    def get_engine(self, DBMS_CONFIG):
        engine = create_engine(DBMS_CONFIG)
        return engine
