from pydantic import BaseSettings, Field


class EpiwatchSettings(BaseSettings):
    WEBSITE_CORS_ALLOWED_ORIGINS: str = Field(default="", env="WEBSITE_CORS_ALLOWED_ORIGINS")

    PSQL_SERVER: str = Field(default="", env="PSQL_SERVER")
    PSQL_PORT: int = Field(default=5432, env="PSQL_PORT")
    PSQL_DB: str = Field(default="testing_db", env="PSQL_DB")
    PSQL_USERNAME: str = Field(default="epi_api", env="PSQL_USERNAME")
    PSQL_PASSWORD: str = Field(default="", env="PSQL_PASSWORD")
    STATIC_DIR: str = Field(default="/data/epiwatch", env="STATIC_DIR")
    SECURITY_LOG_NAME: str = Field(default="apiasecurity", env="SECURITY_LOG_NAME")

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"
        case_sensitive = True
