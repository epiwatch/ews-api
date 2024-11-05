from typing import Annotated, List

from fastapi import APIRouter, Depends, HTTPException, Request, Response, status

from app.dependencies.db_mod import Database
from app.dependencies.logger import get_logger
from app.dependencies.map_functions import get_report_count_per_country_orm, map_endpoint
from app.dependencies.schemas import MapEndpointInput, MapOutput, NumReportsPerCountry

logger = get_logger("api")
router = APIRouter()


@router.get("/map", tags=["Map"], status_code=status.HTTP_200_OK, response_model=MapOutput)
def map_data(map_input: Annotated[MapEndpointInput, Depends(MapEndpointInput)], request: Request, response: Response):
    """
    Description: \n
    This is the main endpoint for the maps page on the dashboard.
    The data returned by this endpoint feeds into clustered markers used on the frontend \n
    This function retrieves an aggregate of report counts for each country. \n
    This result is constrained by specified diseases, syndromes and time boundaries \n
    The actual report content, on a per country basis will be covered by a seperate endpoint: reportsincountry
    """
    try:
        return map_endpoint(request, map_input)
    except Exception as e:
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        logger.error(f"map endpoint not working: {e}")
        raise HTTPException(status_code=500, detail="/map endpoint not working")


@router.get("/numreportspercountry", tags=["Map"], status_code=status.HTTP_200_OK, response_model=List[NumReportsPerCountry])
async def num_reports_per_country(map_input: Annotated[MapEndpointInput, Depends(MapEndpointInput)], request: Request, response: Response):
    """
    Count the number of reports per country \n
    \n this method will be reused for every country in the /map endpoint \n
    Params: country_id (iso3), diseases, syndromes, dates

    For now, just get the total value of reports in a country. This is necessary to figure out key ORM functionality
    """
    try:
        with request.state.sessionmaker() as current_session:
            db = Database(current_session)
            results_orm = get_report_count_per_country_orm(
                db, start_date=map_input.start_date, end_date=map_input.end_date, disease_list=map_input.disease_list, syndrome_list=map_input.syndrome_list, lang=map_input.lang
            )
            return results_orm
    except Exception as e:
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        logger.error(f"numreportspercountry endpoint not working: {e}")
        raise HTTPException(status_code=500, detail="numreportspercountry endpoint not working")
