import hashlib
from datetime import date, timedelta
from typing import Annotated, List

from fastapi import APIRouter, Depends, HTTPException, Request, Response, status
from fastapi.responses import JSONResponse

from app.dependencies.db_mod import APIQueryBuilder, Database
from app.dependencies.logger import get_logger
from app.dependencies.models import Article, ArticleReviewdataPoint, ArticleReviewdataPointNlp
from app.dependencies.schemas import DatasetOutput, InsertArticleInput
from ner.NLP_MODELS import NlpParser, ScrapedGoogleArticle

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
    except PermissionError:
        response.status_code = status.HTTP_403_FORBIDDEN
        raise HTTPException(status_code=403, detail="Insufficient permissions to access this resource")
    except Exception as e:
        logger.error(f"reports endpoint not working: {e}")
        raise HTTPException(status_code=500, detail="/reports endpoint not working")


@router.get("/insert_article", tags=["Dataset"], status_code=status.HTTP_200_OK)
def insert_article(article_input: Annotated[InsertArticleInput, Depends(InsertArticleInput)], request: Request, lang: str | None = "en"):
    """
    This endpoint adds an article to the database after being formatted.
    """
    try:
        with request.state.sessionmaker() as current_session:
            api = APIQueryBuilder(lang=lang)
            query = api.static_get_diseases()
            db = Database(current_session)

            diseases = db.session.execute(query).all()

            diseases = [{"disease_id": item[0], "disease_variation": item[1]} for item in diseases]
            query = api.static_get_syndromes()
            syndromes = db.session.execute(query).all()
            syndromes = [{"syndrome_id": item[0], "syndrome_variation": item[2]} for item in syndromes]

            parser = NlpParser(False, diseases, syndromes)
            article = ScrapedGoogleArticle(article_input.title, article_input.date, article_input.body, article_input.url)
            parsed_article = parser.translate_article(article)
            blank_article = insert_blank_article(article.url, epiwatch_hash_url(article.url))
            db.session.add(blank_article)
            db.session.flush()
            articleID = blank_article.id
            title = insert_articledatapt(articleID, parsed_article.tran_title, 2)

            body = insert_articledatapt(articleID, parsed_article.tran_body, 3)
            date = insert_articledatapt(articleID, article_input.date, 4)
            db.session.add(title)
            db.session.add(body)
            db.session.add(date)
            db.session.flush()

            for title_nlp in parsed_article.nlp_list[0]:
                nlp_val = insert_ardp_nlp(title.id, title_nlp["nlp_index"], title_nlp["display_text"], title_nlp["value"], title_nlp["category"])
                db.session.add(nlp_val)

            for body_nlp in parsed_article.nlp_list[1]:
                nlp_val = insert_ardp_nlp(body.id, body_nlp["nlp_index"], body_nlp["display_text"], body_nlp["value"], body_nlp["category"])
                db.session.add(nlp_val)
            print("successfully added")

            return JSONResponse(status_code=200, content="Article Succssfully added")
    except PermissionError:
        db.rollback()
        return JSONResponse(status_code=403, content="Insufficient permissions")
    except Exception as e:
        logger.error(f"reports endpoint not working: {e}")
        return JSONResponse(status_code=500, content="Endpoint not working")


def insert_blank_article(url, unique_hash):

    reviewed = 0
    accepted = 0
    blocked = 0
    audited = 0
    skipped = 0
    flagged = 0
    language_detection_method_id = 0
    language_code = None
    language_name = None
    flag_comments = None
    original_priority_score = 1
    suggested_priority_score = None
    hashed_value = url

    sql = Article(
        reviewed=reviewed,
        audited=audited,
        flagged=flagged,
        accepted=accepted,
        blocked=blocked,
        skipped=skipped,
        language_detection_method_id=language_detection_method_id,
        language_code=language_code,
        language_name=language_name,
        unique_hash=unique_hash,
        hashed_value=hashed_value,
        flag_comments=flag_comments,
        original_priority_score=original_priority_score,
        suggested_priority_score=suggested_priority_score,
    )
    return sql


def epiwatch_hash_url(url_str: str):
    encoded_url = url_str.encode("utf-8")
    sha256_hash = hashlib.sha256()
    sha256_hash.update(encoded_url)
    hashed_value = sha256_hash.hexdigest()
    return hashed_value


def insert_articledatapt(article_id, value, field_id) -> int | None:

    if field_id == 4:
        pass
    else:
        pass
    if field_id == 1:
        pass
    else:
        pass

    stmt = ArticleReviewdataPoint(article_id=article_id, article_reviewdata_field_id=field_id, value=value)
    return stmt


def insert_ardp_nlp(ardp_id, nlp_index, display_text, value, ner_tag_category):
    nlp_obj = ArticleReviewdataPointNlp(article_reviewdata_point_id=ardp_id, nlp_index=nlp_index, display_text=display_text, value=value, category=ner_tag_category)
    return nlp_obj
