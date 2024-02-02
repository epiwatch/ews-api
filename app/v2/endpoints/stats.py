from typing import Annotated, List

from fastapi import APIRouter, Depends, HTTPException, Request, Response, status

from app.dependencies.db_mod import APIQueryBuilder, Database
from app.dependencies.functions import generate_illness_count, generate_report_diseases_in_range, get_all_isos_sbregion_orm, illnessInRegionORM, log_input, process_orm_res
from app.dependencies.logger import get_logger
from app.dependencies.schemas import Stats_Params, TopTenDiseaseOutput

logger = get_logger("api")
router = APIRouter()


@router.get("/countryTop10Diseases", tags=["Stats page - Gets"], status_code=status.HTTP_200_OK, response_model=List[TopTenDiseaseOutput])
def get_top_10_diseases(country_id: int, start_date: str, end_date: str, request: Request, response: Response, lang: str | None = "en"):
    """
    If "auto top 10 diseases" is turned, need to extract that data for the selected country
    """
    try:
        with request.state.sessionmaker() as current_session:
            db = Database(current_session)
            query = APIQueryBuilder(lang=lang).stats_top_ten_diseases_orm(country_id, start_date, end_date)
            result = db.session.execute(query).all()
            if len(result) == 0:
                logger.info(f"Null result for top ten diseases for country id: {country_id}")
                return result
            logger.info("top ten diseases endpoint successful")
        return result
    except Exception as e:
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        logger.error(f"Internal server {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


# old name reportDiseasesInRange
@router.get("/reportIllnessesInRange", tags=["Stats page - Gets"], status_code=status.HTTP_200_OK)
def statsbarchart(stats_input: Annotated[Stats_Params, Depends(Stats_Params)], request: Request, response: Response):
    """
    ## STACKED BAR CHART
    """
    try:
        with request.state.sessionmaker() as current_session:
            db = Database(current_session)
            log_input("reportIllnessesInRange", stats_input)
            query = APIQueryBuilder(lang=stats_input.lang).stats_reportIllnessInRangeORM(
                stats_input.start_date, stats_input.end_date, stats_input.country_id, disease_ids=stats_input.disease_ids, syndrome_ids=stats_input.syndrome_ids
            )
            rows = db.session.execute(query).all()
            results = process_orm_res(rows)
            if len(results) == 0:
                logger.info("No data records retrieved for /reportIllnessesInRange endpoint")
                return
            logger.info("reportIllnessesInRange endpoint working")
            formatted_results = generate_report_diseases_in_range(results)
        return formatted_results
    except Exception:
        raise HTTPException(status_code=500, detail="Internal server error")


@router.get("/reportIllnessInCountry", tags=["Stats page - Gets"], status_code=status.HTTP_200_OK)
async def country_pie_chart(stats_input: Annotated[Stats_Params, Depends(Stats_Params)], request: Request, response: Response):
    """
    ## COUNTRY PIE CHART
    ReportIllnessInLocation -- count per illness per country
    """
    try:
        with request.state.sessionmaker() as current_session:
            db = Database(current_session)
            log_input("reportIllnessInCountry", stats_input)
            query = APIQueryBuilder(lang=stats_input.lang).stats_reportIllnessInCountryORM(
                stats_input.start_date, stats_input.end_date, stats_input.country_id, stats_input.disease_ids, stats_input.syndrome_ids
            )
            result = db.session.execute(query).all()
            result = process_orm_res(result)
            result = generate_illness_count(result)

            if result is None:
                logger.info("No data records retrieved for /reportIllnessInCountry endpoint")
                return
            logger.info("reportIllnessInCountry endpoint working")
        return result
    except Exception as e:
        response.status_code = status.HTTP_400_BAD_REQUEST
        logger.error(f"reportIllnessInCountry endpoint not working: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@router.get("/reportIllnessesInRegion", tags=["Stats page - Gets"], status_code=status.HTTP_200_OK)
async def region_pie_chart(stats_input: Annotated[Stats_Params, Depends(Stats_Params)], request: Request, response: Response):
    """
    Only look in subregions
    """
    try:
        with request.state.sessionmaker() as current_session:
            db = Database(current_session)
            logger.info(f"reportIllnessesInRegion PARAMS: {stats_input}")
            country_ids = get_all_isos_sbregion_orm(db, stats_input.country_id)
            query = APIQueryBuilder(lang=stats_input.lang).stats_ReportsInRegion(
                stats_input.start_date, stats_input.end_date, country_ids, stats_input.disease_ids, stats_input.syndrome_ids
            )
            orm_results = illnessInRegionORM(
                db, stats_input.start_date, stats_input.end_date, country_ids, stats_input.disease_ids, stats_input.syndrome_ids, lang=stats_input.lang
            )
            orm_results = db.session.execute(query).all()
            orm_results = process_orm_res(orm_results)
            orm_results = generate_illness_count(orm_results)
            logger.info("reportIllnessesInRegion succesfully ran")
            return orm_results
    except Exception as e:
        response.status_code = status.HTTP_400_BAD_REQUEST
        logger.error(f"GET - reportIllnessesInRegion: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")
