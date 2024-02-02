import os

from dotenv import load_dotenv
from fastapi import HTTPException
from sqlalchemy import DateTime, cast, create_engine, desc, func, select, text, union_all

from app.dependencies.logger import get_logger
from app.dependencies.models import (
    CountryData,
    Disease,
    Regions,
    Report,
    ReportDataPoint,
    ReportDataPointDisease,
    ReportDataPointLocation,
    ReportDataPointSyndrome,
    Subregions,
    Syndrome,
)

logger = get_logger("api")


class APIQueryBuilder:
    def __init__(self, lang) -> None:
        self.lang = lang
        try:
            self.determine_disease()
            self.determine_syndrome()
            self.determine_country()
        except:
            raise HTTPException(status_code=400, detail="Invalid language selection")

    def determine_disease(self):
        lang_opts = {"hi": Disease.hindi_translation, "en": Disease.disease}
        self.dis_col = lang_opts[self.lang]

    def determine_syndrome(self):
        lang_opts = {"hi": Syndrome.hindi_translation, "en": Syndrome.syndrome}
        self.syndrome_col = lang_opts[self.lang]

    def determine_country(self):
        lang_opts = {"hi": CountryData.hindi_translation, "en": CountryData.country_name}
        self.country_col = lang_opts[self.lang]
        subregion_lang = {"hi": Subregions.hindi_translation, "en": Subregions.subregion}
        self.subregion_col = subregion_lang[self.lang]

    # add colour back
    def static_get_diseases(self):
        orm_sql = select(Disease.id, self.dis_col.label("disease"), Disease.colour).select_from(Disease).where(Disease.active == 1)
        return orm_sql

    def static_get_syndromes(self):
        orm_sql = select(Syndrome.id, Syndrome.colour, self.syndrome_col.label("syndrome"), Syndrome.colour).select_from(Syndrome).where(Syndrome.active == 1)
        return orm_sql

    def static_get_countries(self):
        countries_orm = (
            select(
                CountryData.id,
                CountryData.iso3,
                self.country_col.label("country_name"),
                CountryData.latitude.label("lat"),
                CountryData.longitude.label("long"),
                self.subregion_col.label("subregion"),
                Regions.region,
            )
            .select_from(CountryData)
            .join(Subregions, Subregions.iso3 == CountryData.iso3)
            .join(Regions, Regions.iso3 == CountryData.iso3)
        )
        return countries_orm

    def get_reports_orm(self, start_date, end_date):
        minimal_length = 9
        sydrome_subq = (
            select(ReportDataPointSyndrome.report_id, func.string_agg(self.syndrome_col, "/").label("syndromes"))
            .select_from(ReportDataPointSyndrome)
            .join(Syndrome, Syndrome.id == ReportDataPointSyndrome.syndrome_id)
            .group_by(ReportDataPointSyndrome.report_id, Syndrome.syndrome, Syndrome.hindi_translation)
            .subquery()
        )

        disease_subq = (
            select(ReportDataPointDisease.report_id, func.string_agg(self.dis_col, "/").label("diseases"))
            .select_from(ReportDataPointDisease)
            .join(Disease, Disease.id == ReportDataPointDisease.disease_id)
            .group_by(ReportDataPointDisease.report_id, Disease.disease, Disease.hindi_translation)
            .subquery()
        )

        datapts_subq = (
            select(ReportDataPoint.report_id, ReportDataPoint.value.label("date"))
            .select_from(ReportDataPoint)
            .where(ReportDataPoint.report_data_field_id == 3)
            .where(func.length(ReportDataPoint.value) > minimal_length)
            .where(cast(ReportDataPoint.value, DateTime).between(start_date, end_date))
            .subquery()
        )

        location_subq = (
            select(ReportDataPointLocation.report_id, self.country_col.label("location"))
            .select_from(ReportDataPointLocation)
            .join(CountryData, CountryData.id == ReportDataPointLocation.country_id)
            .subquery()
        )

        full_stmt = (
            select(Report.id, disease_subq.c.diseases, sydrome_subq.c.syndromes, location_subq.c.location, datapts_subq.c.date)
            .select_from(Report)
            .join(datapts_subq, datapts_subq.c.report_id == Report.id)
            .join(disease_subq, disease_subq.c.report_id == Report.id)
            .join(sydrome_subq, sydrome_subq.c.report_id == Report.id)
            .join(location_subq, location_subq.c.report_id == Report.id)
            .where(func.length(datapts_subq.c.date) > minimal_length)
            .where(cast(datapts_subq.c.date, DateTime).between(start_date, end_date))
            .order_by(desc(datapts_subq.c.date))
        )
        return full_stmt

    def stats_top_ten_diseases_orm(self, country_id, start_date, end_date, lang: str | None = "en"):
        minimal_length = 9
        stmt = (
            select(Disease.id, self.dis_col.label("disease"), func.count(ReportDataPointDisease.disease_id).label("num"))
            .select_from(ReportDataPointDisease)
            .join(Disease, Disease.id == ReportDataPointDisease.disease_id)
            .join(ReportDataPointLocation, ReportDataPointLocation.report_id == ReportDataPointDisease.report_id)
            .join(ReportDataPoint, (ReportDataPoint.report_id == ReportDataPointDisease.id) & (ReportDataPoint.report_data_field_id == 3))
            .where(ReportDataPointLocation.country_id == country_id)
            .where(func.length(ReportDataPoint.value) > minimal_length)
            .where(cast(ReportDataPoint.value, DateTime).between(start_date, end_date))
            .group_by(Disease.disease, Disease.id)
            .order_by(desc("num"))
            .limit(10)
        )
        return stmt

    def stats_reportIllnessInRangeORM(self, start_date, end_date, country_id, disease_ids, syndrome_ids):
        minimal_length = 9
        dis_sql = (
            select(ReportDataPoint.value.label("date"), self.dis_col.label("illness"), func.count(Report.id).label("count"))
            .select_from(Report)
            .join(ReportDataPointLocation, ReportDataPointLocation.report_id == Report.id)
            .join(ReportDataPointDisease, ReportDataPointDisease.report_id == Report.id)
            .join(Disease, Disease.id == ReportDataPointDisease.disease_id)
            .join(ReportDataPoint, (ReportDataPoint.report_id == Report.id) & (ReportDataPoint.report_data_field_id == 3))
            .where(ReportDataPointLocation.country_id == country_id)
            .where(func.length(ReportDataPoint.value) > minimal_length)
            .where(cast(ReportDataPoint.value, DateTime).between(start_date, end_date))
            .where(Disease.disease.is_not(None))
            .where(Disease.id.in_(disease_ids))
            .group_by(Disease.disease, ReportDataPoint.value, Disease.hindi_translation)
        )

        syndrome_sql = (
            select(ReportDataPoint.value.label("date"), self.syndrome_col.label("illness"), func.count(Report.id).label("count"))
            .select_from(Report)
            .join(ReportDataPointLocation, ReportDataPointLocation.report_id == Report.id)
            .join(ReportDataPointSyndrome, ReportDataPointSyndrome.report_id == Report.id)
            .join(Syndrome, Syndrome.id == ReportDataPointSyndrome.syndrome_id)
            .join(ReportDataPoint, (ReportDataPoint.report_id == Report.id) & (ReportDataPoint.report_data_field_id == 3))
            .where(ReportDataPointLocation.country_id == country_id)
            .where(func.length(ReportDataPoint.value) > minimal_length)
            .where(cast(ReportDataPoint.value, DateTime).between(start_date, end_date))
            .where(Syndrome.syndrome.is_not(None))
            .where(Syndrome.id.in_(syndrome_ids))
            .group_by(Syndrome.syndrome, ReportDataPoint.value, Syndrome.hindi_translation)
        )

        stmt = union_all(dis_sql, syndrome_sql)
        return stmt

    def stats_reportIllnessInCountryORM(self, start_date, end_date, country_id, disease_ids, syndrome_ids):
        minimal_length = 9
        dis_subq = (
            select(self.dis_col.label("illness"), func.count(Report.id).label("num"))
            .select_from(Report)
            .join(ReportDataPointLocation, ReportDataPointLocation.report_id == Report.id)
            .join(ReportDataPointDisease, ReportDataPointDisease.report_id == Report.id)
            .join(Disease, ReportDataPointDisease.disease_id == Disease.id)
            .join(ReportDataPoint, ReportDataPoint.report_id == Report.id)
            .where(ReportDataPoint.report_data_field_id == 3)
            .where(func.length(ReportDataPoint.value) > minimal_length)
            .where(ReportDataPointLocation.country_id == country_id)
            .where(Disease.id.in_(disease_ids))
            .where(cast(ReportDataPoint.value, DateTime).between(start_date, end_date))
            .group_by(ReportDataPointDisease.disease_id, Disease.disease, Disease.hindi_translation)
        )

        syndrome_sub = (
            select(self.syndrome_col.label("illness"), func.count(Report.id))
            .select_from(Report)
            .join(ReportDataPointLocation, ReportDataPointLocation.report_id == Report.id)
            .join(ReportDataPointSyndrome, ReportDataPointSyndrome.report_id == Report.id)
            .join(Syndrome, ReportDataPointSyndrome.syndrome_id == Syndrome.id)
            .join(ReportDataPoint, ReportDataPoint.report_id == Report.id)
            .where(ReportDataPoint.report_data_field_id == 3)
            .where(func.length(ReportDataPoint.value) > minimal_length)
            .where(ReportDataPointLocation.country_id == country_id)
            .where(Syndrome.id.in_(syndrome_ids))
            .where(cast(ReportDataPoint.value, DateTime).between(start_date, end_date))
            .group_by(ReportDataPointSyndrome.syndrome_id, Syndrome.syndrome, Syndrome.hindi_translation)
        )

        stmt = union_all(dis_subq, syndrome_sub)
        return stmt

    def stats_ReportsInRegion(self, start_date, end_date, country_ids, disease_list, syndrome_list):
        minimal_length = 9

        stmt = (
            select(self.dis_col.label("illness"), func.count(Report.id).label("num"))
            .select_from(Report)
            .join(ReportDataPointLocation, ReportDataPointLocation.report_id == Report.id)
            .join(ReportDataPointDisease, ReportDataPointDisease.report_id == Report.id)
            .join(Disease, ReportDataPointDisease.disease_id == Disease.id)
            .join(ReportDataPoint, ReportDataPoint.report_id == Report.id)
            .where(ReportDataPoint.report_data_field_id == 3)
            .where(func.length(ReportDataPoint.value) > minimal_length)
            .where(ReportDataPointLocation.country_id.in_(country_ids))
            .where(Disease.id.in_(disease_list))
            .where(cast(ReportDataPoint.value, DateTime).between(start_date, end_date))
            .group_by(ReportDataPointDisease.disease_id, Disease.disease, Disease.hindi_translation)
        )

        syn_stmt = (
            select(self.syndrome_col.label("illness"), func.count(Report.id).label("num"))
            .select_from(Report)
            .join(ReportDataPointLocation, ReportDataPointLocation.report_id == Report.id)
            .join(ReportDataPointSyndrome, ReportDataPointSyndrome.report_id == Report.id)
            .join(Syndrome, ReportDataPointSyndrome.syndrome_id == Syndrome.id)
            .join(ReportDataPoint, ReportDataPoint.report_id == Report.id)
            .where(ReportDataPoint.report_data_field_id == 3)
            .where(func.length(ReportDataPoint.value) > minimal_length)
            .where(ReportDataPointLocation.country_id.in_(country_ids))
            .where(Syndrome.id.in_(syndrome_list))
            .where(cast(ReportDataPoint.value, DateTime).between(start_date, end_date))
            .group_by(ReportDataPointSyndrome.syndrome_id, Syndrome.syndrome, Syndrome.hindi_translation)
        )

        full_smt = union_all(stmt, syn_stmt)
        return full_smt


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

    def get_table(self, table):
        query_str = f"""
        SELECT * FROM {table};
        """
        try:
            tbl_res = self.process_results(query_str)
            return tbl_res
        except Exception as e:
            logger.error(f"Failed getting table results for {table} : {e}")
            return None
