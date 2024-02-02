from typing import Dict, List

from sqlalchemy import DateTime, case, cast, func, select, union_all

from app.dependencies.db_mod import Database
from app.dependencies.logger import get_logger
from app.dependencies.models import CountryData, Disease, Report, ReportDataPoint, ReportDataPointDisease, ReportDataPointLocation, ReportDataPointSyndrome, Subregions, Syndrome
from app.dependencies.schemas import Stats_Params

logger = get_logger("api")


def check_valid_stats(selection: Stats_Params, country_bound, syndrome_bound, disease_bound) -> bool:
    if ((selection.country_id >= 0 and selection.country_id <= country_bound)) and (selection.start_date < selection.end_date):
        if (selection.disease_ids is None) and (selection.syndrome_ids is None):
            return False
        if selection.disease_ids is not None:
            for item in selection.disease_ids:
                if item < 0 or item > disease_bound:
                    return False
        if selection.syndrome_ids is not None:
            for item in selection.syndrome_ids:
                if item < 0 or item > syndrome_bound:
                    return False
        return True
    else:
        return False


def log_input(api_call: str, stats_input: Stats_Params) -> None:
    logger.info(
        f"""API CALL: {api_call}, PARAMS-- START DATE:{stats_input.start_date} END DATE: {stats_input.end_date},
        COUNTRY ID: {stats_input.country_id}, DISEASE IDS:{stats_input.disease_ids}, SYNDROME IDS: {stats_input.syndrome_ids}"""
    )


def get_all_isos_sbregion_orm(db: Database, country_id):
    # get region name
    country_query = select(CountryData.iso3).where(CountryData.id == country_id)
    iso3 = db.session.execute(country_query).scalars().one()
    region_query = select(Subregions.subregion).where(Subregions.iso3 == iso3)
    target_region = db.session.execute(region_query).scalars().one()
    all_isos = select(Subregions.iso3).where(Subregions.subregion == target_region)
    all_isos = db.session.execute(all_isos).scalars().all()
    all_country_q = select(CountryData.id).where(CountryData.iso3.in_(all_isos))
    all_country_ids = db.session.execute(all_country_q).scalars().all()
    return all_country_ids


def reportIllnessInCountryORM(db: Database, start_date, end_date, diseases, syndromes, country_id, lang: str | None):
    minimal_length = 9
    dis_subq = (
        select(case((lang == "hi", Disease.hindi_translation), else_=Disease.disease).label("illness"), func.count(Report.id).label("num"))
        .select_from(Report)
        .join(ReportDataPointLocation, ReportDataPointLocation.report_id == Report.id)
        .join(ReportDataPointDisease, ReportDataPointDisease.report_id == Report.id)
        .join(Disease, ReportDataPointDisease.disease_id == Disease.id)
        .join(ReportDataPoint, ReportDataPoint.report_id == Report.id)
        .where(ReportDataPoint.report_data_field_id == 3)
        .where(func.length(ReportDataPoint.value) > minimal_length)
        .where(ReportDataPointLocation.country_id == country_id)
        .where(Disease.id.in_(diseases))
        .where(cast(ReportDataPoint.value, DateTime).between(start_date, end_date))
        .group_by(ReportDataPointDisease.disease_id, Disease.disease, Disease.hindi_translation)
    )

    syndrome_sub = (
        select(case((lang == "hi", Syndrome.hindi_translation), else_=Syndrome.syndrome).label("illness"), func.count(Report.id))
        .select_from(Report)
        .join(ReportDataPointLocation, ReportDataPointLocation.report_id == Report.id)
        .join(ReportDataPointSyndrome, ReportDataPointSyndrome.report_id == Report.id)
        .join(Syndrome, ReportDataPointSyndrome.syndrome_id == Syndrome.id)
        .join(ReportDataPoint, ReportDataPoint.report_id == Report.id)
        .where(ReportDataPoint.report_data_field_id == 3)
        .where(func.length(ReportDataPoint.value) > minimal_length)
        .where(ReportDataPointLocation.country_id == country_id)
        .where(Syndrome.id.in_(syndromes))
        .where(cast(ReportDataPoint.value, DateTime).between(start_date, end_date))
        .group_by(ReportDataPointSyndrome.syndrome_id, Syndrome.syndrome, Syndrome.hindi_translation)
    )

    stmt = union_all(dis_subq, syndrome_sub)
    rows = db.session.execute(stmt).all()
    return rows


def reportIllnessInCountryORMAllDiseases(db: Database, start_date, end_date, syndromes, country_id, lang):
    # COUNTRY PIE CHART: COUNT VALUES FOR EACH DISEASES AND SYNDROME PER COUNTRY
    minimal_length = 9
    dis_subq = (
        # case((lang == "hi", Disease.hindi_translation), else_=Disease.disease).label("illness"), func.count(Report.id).label("num")
        select(case((lang == "hi", Disease.hindi_translation), else_=Disease.disease).label("illness"), func.count(Report.id).label("num"))
        .select_from(Report)
        .join(ReportDataPointLocation, ReportDataPointLocation.report_id == Report.id)
        .join(ReportDataPointDisease, ReportDataPointDisease.report_id == Report.id)
        .join(Disease, ReportDataPointDisease.disease_id == Disease.id)
        .join(ReportDataPoint, ReportDataPoint.report_id == Report.id)
        .where(ReportDataPoint.report_data_field_id == 3)
        .where(func.length(ReportDataPoint.value) > minimal_length)
        .where(ReportDataPointLocation.country_id == country_id)
        .where(cast(ReportDataPoint.value, DateTime).between(start_date, end_date))
        .group_by(ReportDataPointDisease.disease_id, Disease.disease, Disease.hindi_translation)
    )

    syndrome_sub = (
        select(case((lang == "hi", Syndrome.hindi_translation), else_=Syndrome.syndrome).label("illness"), func.count(Report.id))
        .select_from(Report)
        .join(ReportDataPointLocation, ReportDataPointLocation.report_id == Report.id)
        .join(ReportDataPointSyndrome, ReportDataPointSyndrome.report_id == Report.id)
        .join(Syndrome, ReportDataPointSyndrome.syndrome_id == Syndrome.id)
        .join(ReportDataPoint, ReportDataPoint.report_id == Report.id)
        .where(ReportDataPoint.report_data_field_id == 3)
        .where(func.length(ReportDataPoint.value) > minimal_length)
        .where(ReportDataPointLocation.country_id == country_id)
        .where(Syndrome.id.in_(syndromes))
        .where(cast(ReportDataPoint.value, DateTime).between(start_date, end_date))
        .group_by(ReportDataPointSyndrome.syndrome_id, Syndrome.syndrome, Syndrome.hindi_translation)
    )

    stmt = union_all(dis_subq, syndrome_sub)
    rows = db.session.execute(stmt).all()
    return rows


def illnessInRegionORM(db: Database, start_date: str, end_date: str, country_ids, disease_list: List[int] | None, syndrome_list: List[int] | None, lang: str):
    minimal_length = 9

    stmt = (
        select(case((lang == "hi", Disease.hindi_translation), else_=Disease.disease).label("illness"), func.count(Report.id).label("num"))
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
        select(case((lang == "hi", Syndrome.hindi_translation), else_=Syndrome.syndrome).label("illness"), func.count(Report.id).label("num"))
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
    rows = db.session.execute(full_smt).all()
    return process_orm_res(rows)


def process_orm_res(result):
    return [dict(r._mapping) for r in result]


## REVERSE EPIRISK CALCU:AOR


def generate_report_diseases_in_range(results):
    formatted: Dict = {}
    for res in results:
        date = res["date"]
        illness = res["illness"]
        ill_num = res["count"]
        new_item = {illness: ill_num}
        if date not in formatted.keys():
            formatted[date] = new_item
        else:
            formatted[date].update(new_item)
    return formatted


def structure_regions(data, rg_type):
    subregions: Dict = {}
    subregion_coll: list = []
    for entry in data:
        if entry[rg_type] not in subregion_coll:
            subregion_coll.append(entry[rg_type])
            subregions[entry[rg_type]] = []
            subregions[entry[rg_type]].append(entry["iso3"])
        else:
            subregions[entry[rg_type]].append(entry["iso3"])
    return subregions


def generate_disease_count(data):
    disease_count = {}
    for item in data:
        disease = item["illness"]
        count = item["count"]
        disease_count[disease] = count

    return disease_count


def generate_illness_count(data):
    illness_count = {}
    for item in data:
        illness = item["illness"]
        count = item["num"]
        illness_count[illness] = count
    return illness_count
