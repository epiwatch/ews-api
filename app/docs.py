from typing import Final

VERSION: Final[str] = "0.0.1"
description = """
EPIWATCH API is a REST service that retrieves disease, syndrome and location data for front end users


"""

tags_metadata = [
    {"name": "Static Data", "description": "Retrieve static data from database"},
    {"name": "Stats page - Gets", "description": "Aggregate disease, syndrome and location values given user input"},
    {"name": "dynamic - dataset", "description": "Retrieve all relevant report data"},
    {"name": "Dataset"},
    {"name": "Map", "description": "data retrieval for map page"},
]
