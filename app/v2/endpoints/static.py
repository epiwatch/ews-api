from typing import List

from fastapi import APIRouter, HTTPException, Request, Response, status

from app.dependencies.db_mod import APIQueryBuilder, Database
from app.dependencies.functions import structure_regions
from app.dependencies.logger import get_logger
from app.dependencies.schemas import CountryEndpointOutput, DiseaseOutput, SyndromeOutput

logger = get_logger("api")
router = APIRouter()


@router.get("/disease", tags=["static data"], status_code=status.HTTP_200_OK, response_model=List[DiseaseOutput])
def get_selected_diseases(response: Response, request: Request, lang: str | None = "en"):
    try:
        with request.state.sessionmaker() as current_session:
            db = Database(current_session)
            query = APIQueryBuilder(lang=lang).static_get_diseases()
            orm_results = db.session.execute(query).all()
            return orm_results
    except Exception as e:
        logger.error(f"Error: '/disease' endpoint not working: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@router.get("/syndrome", tags=["static data"], status_code=status.HTTP_200_OK, response_model=List[SyndromeOutput])
def get_selected_syndromes(response: Response, request: Request, lang: str | None = "en"):
    try:
        with request.state.sessionmaker() as current_session:
            db = Database(current_session)
            query = APIQueryBuilder(lang=lang).static_get_syndromes()
            orm_results = db.session.execute(query).all()
            logger.info("syndrome endpoint - successful")
        return orm_results
    except Exception as e:
        logger.error(f"Error: '/syndrome' endpoint not working {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@router.get("/countries", status_code=status.HTTP_200_OK, tags=["static data"], response_model=List[CountryEndpointOutput])
def get_countries(response: Response, request: Request, lang: str | None = "en"):
    try:
        with request.state.sessionmaker() as current_session:
            db = Database(current_session)
            query = APIQueryBuilder(lang=lang).static_get_countries()
            country_results = db.session.execute(query).all()
            logger.info("countries endpoint executed successfully")
        return country_results
    except Exception as e:
        logger.error(f"ERROR : {e}")
        raise HTTPException(status_code=500, detail=f"{e}")


@router.get("/subregions", status_code=status.HTTP_200_OK, tags=["static data"])
def get_subregions(response: Response, request: Request):
    try:
        with request.state.sessionmaker() as current_session:
            db = Database(current_session)
            result = db.get_table("subregions")
            logger.info("subregions endpoint working as expected")
            result = structure_regions(result, "subregion")
        return result
    except Exception as e:
        logger.error(f"subregions endpoint not working: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@router.get("/regions", status_code=status.HTTP_200_OK, tags=["static data"])
def get_regions(request: Request, response: Response):
    try:
        with request.state.sessionmaker() as current_session:
            db = Database(current_session)
            regions = db.get_table("regions")
            result = structure_regions(regions, "region")
            logger.info("regions working as expected")
        return result
    except Exception as e:
        logger.error(f"regions endpoint not working: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")
