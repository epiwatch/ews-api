from sqlalchemy import DateTime, case, cast, func, select, union_all

from app.dependencies.functions import generate_illness_count, process_orm_res, reportIllnessInCountryORM, reportIllnessInCountryORMAllDiseases
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
from app.dependencies.schemas import CountryOutput, MapEndpointInput

from . import models
from .db_mod import Database

logger = get_logger("api")


def get_countries_endpoint(db: Database, lang: str | None):
    countries_orm = (
        select(
            CountryData.id,
            CountryData.iso3,
            case((lang == "hi", CountryData.hindi_translation), else_=CountryData.country_name).label("country_name"),
            CountryData.latitude.label("lat"),
            CountryData.longitude.label("long"),
            Subregions.subregion,
            Regions.region,
        )
        .select_from(CountryData)
        .join(Subregions, Subregions.iso3 == CountryData.iso3)
        .join(Regions, Regions.iso3 == CountryData.iso3)
    )
    country_results = db.session.execute(countries_orm).all()
    return country_results


def map_endpoint(request, map_input: MapEndpointInput):
    start_date = map_input.start_date
    end_date = map_input.end_date
    lang = map_input.lang

    if map_input.disease_list == []:
        ALL_DISEASES = True
    else:
        ALL_DISEASES = False
    disease_list = map_input.disease_list
    syndrome_list = map_input.syndrome_list

    with request.state.sessionmaker() as current_session:
        db = Database(current_session)
        map_obj = {"start_date": start_date, "end_date": end_date, "country_list": []}

        if ALL_DISEASES is True:
            report_counts_orm = get_report_count_per_country_orm_all_diseases(db, start_date=start_date, end_date=end_date, syndrome_list=syndrome_list, lang=lang)
        else:
            report_counts_orm = get_report_count_per_country_orm(db, start_date=start_date, end_date=end_date, disease_list=disease_list, syndrome_list=syndrome_list, lang=lang)
        for res in report_counts_orm:
            country_object = {}
            country_object["country"] = res["country"]
            country_object["continent"] = res["region"]
            country_object["report_count"] = res["report_count"]
            countryid = res["country_id"]
            country_object["iso3"] = res["iso3"]
            country_object["lat"] = res["lat"]
            country_object["long"] = res["long"]

            if ALL_DISEASES is False:
                country_illnesses = reportIllnessInCountryORM(
                    db, start_date=start_date, end_date=end_date, country_id=countryid, diseases=disease_list, syndromes=syndrome_list, lang=lang
                )
            else:
                country_illnesses = reportIllnessInCountryORMAllDiseases(db, start_date=start_date, end_date=end_date, country_id=countryid, syndromes=syndrome_list, lang=lang)
            processed_country_illness = process_orm_res(country_illnesses)
            illness_object = generate_illness_count(processed_country_illness)
            country_object["illness"] = illness_object
            map_obj["country_list"].append(country_object)
        logger.info("/map complete")
        return map_obj


def get_report_count_per_country_orm(db, start_date, end_date, disease_list, syndrome_list, lang: str | None):
    minimal_length = 9
    stmt = (
        select(
            CountryData.id.label("country_id"),
            CountryData.iso3,
            CountryData.latitude.label("lat"),
            CountryData.longitude.label("long"),
            case((lang == "hi", CountryData.hindi_translation), else_=CountryData.country_name).label("country"),
            func.count(Report.id).label("report_count"),
            Regions.region,
        )
        .select_from(Report)
        .join(ReportDataPointLocation, ReportDataPointLocation.report_id == Report.id)
        .join(CountryData, CountryData.id == ReportDataPointLocation.country_id)
        .join(ReportDataPointDisease, ReportDataPointDisease.report_id == Report.id)
        .join(Disease, ReportDataPointDisease.disease_id == Disease.id)
        .join(ReportDataPoint, ReportDataPoint.report_id == Report.id)
        .join(Regions, Regions.iso3 == CountryData.iso3)
        .where(ReportDataPoint.report_data_field_id == 3)
        .where(func.length(ReportDataPoint.value) > minimal_length)
        .where(Disease.id.in_(disease_list))
        .where(cast(ReportDataPoint.value, DateTime).between(start_date, end_date))
        .group_by(CountryData.id, CountryData.country_name, CountryData.hindi_translation, Regions.region)
    )

    syn_stmt = (
        select(
            CountryData.id.label("country_id"),
            CountryData.iso3,
            CountryData.latitude.label("lat"),
            CountryData.longitude.label("long"),
            case((lang == "hi", CountryData.hindi_translation), else_=CountryData.country_name).label("country"),
            func.count(Report.id).label("report_count"),
            Regions.region,
        )
        .select_from(Report)
        .join(ReportDataPointLocation, ReportDataPointLocation.report_id == Report.id)
        .join(CountryData, CountryData.id == ReportDataPointLocation.country_id)
        .join(ReportDataPointSyndrome, ReportDataPointSyndrome.report_id == Report.id)
        .join(Syndrome, ReportDataPointSyndrome.syndrome_id == Syndrome.id)
        .join(ReportDataPoint, ReportDataPoint.report_id == Report.id)
        .join(Regions, Regions.iso3 == CountryData.iso3)
        .where(ReportDataPoint.report_data_field_id == 3)
        .where(func.length(ReportDataPoint.value) > minimal_length)
        .where(Syndrome.id.in_(syndrome_list))
        .where(cast(ReportDataPoint.value, DateTime).between(start_date, end_date))
        .group_by(CountryData.id, CountryData.country_name, Regions.region)
    )

    full_smt = union_all(stmt, syn_stmt)
    rows = db.session.execute(full_smt).all()
    return process_orm_res(rows)


def get_report_count_per_country_orm_all_diseases(db, start_date, end_date, syndrome_list, lang):
    minimal_length = 9
    stmt = (
        select(
            CountryData.id.label("country_id"),
            CountryData.iso3,
            CountryData.latitude.label("lat"),
            CountryData.longitude.label("long"),
            case((lang == "hi", CountryData.hindi_translation), else_=CountryData.country_name).label("country"),
            func.count(Report.id).label("report_count"),
            Regions.region,
        )
        .select_from(Report)
        .join(ReportDataPointLocation, ReportDataPointLocation.report_id == Report.id)
        .join(CountryData, CountryData.id == ReportDataPointLocation.country_id)
        .join(ReportDataPointDisease, ReportDataPointDisease.report_id == Report.id)
        .join(Disease, ReportDataPointDisease.disease_id == Disease.id)
        .join(ReportDataPoint, ReportDataPoint.report_id == Report.id)
        .join(Regions, Regions.iso3 == CountryData.iso3)
        .where(ReportDataPoint.report_data_field_id == 3)
        .where(func.length(ReportDataPoint.value) > minimal_length)
        .where(cast(ReportDataPoint.value, DateTime).between(start_date, end_date))
        .group_by(CountryData.id, CountryData.country_name, Regions.region, CountryData.hindi_translation)
    )

    syn_stmt = (
        select(
            CountryData.id.label("country_id"),
            CountryData.iso3,
            CountryData.latitude.label("lat"),
            CountryData.longitude.label("long"),
            case((lang == "hi", CountryData.hindi_translation), else_=CountryData.country_name).label("country"),
            func.count(Report.id).label("report_count"),
            Regions.region,
        )
        .select_from(Report)
        .join(ReportDataPointLocation, ReportDataPointLocation.report_id == Report.id)
        .join(CountryData, CountryData.id == ReportDataPointLocation.country_id)
        .join(ReportDataPointSyndrome, ReportDataPointSyndrome.report_id == Report.id)
        .join(Syndrome, ReportDataPointSyndrome.syndrome_id == Syndrome.id)
        .join(ReportDataPoint, ReportDataPoint.report_id == Report.id)
        .join(Regions, Regions.iso3 == CountryData.iso3)
        .where(ReportDataPoint.report_data_field_id == 3)
        .where(func.length(ReportDataPoint.value) > minimal_length)
        .where(Syndrome.id.in_(syndrome_list))
        .where(cast(ReportDataPoint.value, DateTime).between(start_date, end_date))
        .group_by(CountryData.id, CountryData.country_name, Regions.region, CountryData.hindi_translation)
    )

    full_smt = union_all(stmt, syn_stmt)
    rows = db.session.execute(full_smt).all()
    return process_orm_res(rows)


def get_country_orm(db: Database, country_input):
    countryISO_Upper = country_input.iso3.upper()
    stmt = (
        select(
            CountryData.iso3.label("id"),
            CountryData.country_name.label("name"),
            CountryData.latitude.label("lat"),
            CountryData.longitude.label("long"),
            Subregions.subregion,
            Regions.region,
        )
        .select_from(CountryData)
        .join(Subregions, Subregions.iso3 == CountryData.iso3)
        .join(Regions, Regions.iso3 == CountryData.iso3)
        .where(CountryData.iso3 == countryISO_Upper)
    )
    result = db.session.execute(stmt)
    dict_result = [dict(zip(result.keys(), row)) for row in result.fetchall()]
    county_value: dict = dict_result[0]

    country_res: CountryOutput = CountryOutput(
        id=county_value["id"], name=county_value["name"], lat=county_value["lat"], long=county_value["long"], subregion=county_value["subregion"], region=county_value["region"]
    )
    return country_res


def get_country_report_endpoint(db, start_date, end_date, country_id, diseases, syndromes, limit=20):
    try:
        subq_data_points = (
            db.session.query(
                models.ReportDataPoint.report_id,
                func.max(case((models.ReportDataPoint.report_data_field_id == 1, models.ReportDataPoint.value), else_=None)).label("url"),
                func.max(case((models.ReportDataPoint.report_data_field_id == 2, models.ReportDataPoint.value), else_=None)).label("title"),
                func.max(case((models.ReportDataPoint.report_data_field_id == 3, models.ReportDataPoint.value), else_=None)).label("publication_date"),
                func.max(case((models.ReportDataPoint.report_data_field_id == 4, models.ReportDataPoint.value), else_=None)).label("event_date"),
            )
            .group_by(models.ReportDataPoint.report_id)
            .subquery()
        )

        subq_diseases = (
            db.session.query(models.ReportDataPointDisease.report_id, func.string_agg(models.Disease.disease, " / ").label("diseases"))
            .join(models.Disease, models.Disease.id == models.ReportDataPointDisease.disease_id)
            .group_by(models.ReportDataPointDisease.report_id)
            .subquery()
        )

        subq_syndromes = (
            db.session.query(models.ReportDataPointSyndrome.report_id, func.string_agg(models.Syndrome.syndrome, " / ").label("syndromes"))
            .join(models.Syndrome, models.Syndrome.id == models.ReportDataPointSyndrome.syndrome_id)
            .group_by(models.ReportDataPointSyndrome.report_id)
            .subquery()
        )

        subq_locations = (
            db.session.query(
                models.ReportDataPointLocation.report_id,
                models.CountryData.id.label("country"),
                func.concat_ws(
                    ", ", func.nullif(models.ReportDataPointLocation.city, ""), func.nullif(models.ReportDataPointLocation.region, ""), models.CountryData.country_name
                ).label("location"),
            )
            .join(models.CountryData, models.CountryData.id == models.ReportDataPointLocation.country_id)
            .subquery()
        )

        query = (
            db.session.query(
                models.Report.id.label("id"),
                subq_diseases.c.diseases,
                subq_syndromes.c.syndromes,
                subq_locations.c.location.label("location"),
                subq_locations.c.country,
                subq_data_points.c.title,
                subq_data_points.c.url,
            )
            .join(subq_data_points, models.Report.id == subq_data_points.c.report_id)
            .join(subq_diseases, models.Report.id == subq_diseases.c.report_id)
            .join(subq_syndromes, models.Report.id == subq_syndromes.c.report_id)
            .join(subq_locations, models.Report.id == subq_locations.c.report_id)
            .filter(
                subq_locations.c.country == country_id,
                subq_diseases.c.diseases.in_(diseases),
                subq_syndromes.c.syndromes.in_(syndromes),
            )
            .limit(10)
        )

        return query

    except Exception as e:
        logger.error(f"{e}")
