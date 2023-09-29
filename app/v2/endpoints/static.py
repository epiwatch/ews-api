import json

from fastapi import APIRouter, Request, Response, status

from app.dependencies.db_mod import Database
from app.dependencies.logger import get_logger
from app.dependencies.models import CountryData, Disease, Regions, Subregions, Syndrome

logger = get_logger("api")
logger.debug("Loading static router")

router = APIRouter()

fn_colour = open("app/data/colours.json")
__colours__ = json.load(fn_colour)


@router.get("/disease", status_code=status.HTTP_200_OK)
def get_selected_diseases(response: Response, request: Request):
    global __colours__
    try:
        with request.state.sessionmaker() as current_session:
            db = Database(current_session)
            result = db.session.query(Disease).all()
            if len(result) == 0:
                logger.error("No data retrieved for /disease endpoint")
                return
            logger.info("disease/ endpoint working")
        return result
    except Exception as e:
        logger.error(f"Error: '/disease' endpoint not working: {e}")
        response.status_code = status.HTTP_400_BAD_REQUEST
        return


@router.get("/syndrome", status_code=status.HTTP_200_OK)
def get_selected_syndromes(response: Response, request: Request):
    try:
        with request.state.sessionmaker() as current_session:
            db = Database(current_session)
            global __colours__
            result = db.session.query(Syndrome).all()
            logger.info("syndrome endpoint - successful")
        return result
    except Exception as e:
        logger.error(f"Error: '/syndrome' endpoint not working {e}")
        response.status_code = status.HTTP_400_BAD_REQUEST
        return "Error"


@router.get("/countries", status_code=status.HTTP_200_OK)
def get_countries(response: Response, request: Request):
    try:
        with request.state.sessionmaker() as current_session:
            db = Database(current_session)
            countries = db.session.query(CountryData).all()
            logger.info("countries endpoint executed as expected")
        return countries
    except Exception as e:
        response.status_code = status.HTTP_400_BAD_REQUEST
        logger.info(f"countries endpoint not working : {e}")


@router.get("/subregions", status_code=status.HTTP_200_OK)
def get_subregions(response: Response, request: Request):
    try:
        with request.state.sessionmaker() as current_session:
            db = Database(current_session)
            result = db.session.query(Subregions).all()
            logger.info("subregions endpoint working as expected")
        return result
    except Exception as e:
        response.status_code = status.HTTP_400_BAD_REQUEST
        logger.error(f"subregions endpoint not working: {e}")


@router.get("/regions")
def get_regions(request: Request, response: Response):
    try:
        with request.state.sessionmaker() as current_session:
            db = Database(current_session)
            regions = db.session.query(Regions).all()
            logger.info("regions working as expected")
        return regions
    except Exception as e:
        logger.error(f"regions endpoint not working: {e}")
        return None


@router.get(
    "/colours",
)
def get_colours(response: Response, request: Request):
    try:
        global __colours__
        logger.info("colours endpoint successful")
        return __colours__
    except Exception as e:
        logger.error(f"regions endpoint not working: {e}")
        return None
