from datetime import date, timedelta
from typing import List

from fastapi import APIRouter, HTTPException, Request, Response, status

from app.dependencies.db_mod import APIQueryBuilder, Database
from app.dependencies.logger import get_logger
from app.dependencies.schemas import DatasetOutput

logger = get_logger("api")
router = APIRouter()


@router.get("/reports", tags=["Dataset"], status_code=status.HTTP_200_OK, response_model=List[DatasetOutput])
def dataset(request: Request, response: Response, lang: str | None = "en"):
    """
    This endpoint populates the datasets table on the respective page.
    """
    try:
        with request.state.sessionmaker() as current_session:
            end_date = date.today().isoformat()
            start_date = (date.today() - timedelta(days=30)).isoformat()
            db = Database(current_session)
            reports_query = APIQueryBuilder(lang=lang).get_reports_orm(start_date, end_date)
            result = db.session.execute(reports_query).all()
            logger.info("reports endpoint working")
            return result
    except Exception as e:
        logger.error(f"reports endpoint not working: {e}")
        raise HTTPException(status_code=500, detail="/reports endpoint not working")
