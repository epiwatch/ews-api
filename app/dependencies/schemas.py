from datetime import date
from typing import Dict, List, Optional

from fastapi import Query
from pydantic import BaseModel


class DiseaseOutput(BaseModel):
    id: int
    disease: str | None
    # should be one or zero
    colour: str

    class Config:
        orm_mode = True


class StaticInput(BaseModel):
    lang: str


class SyndromeOutput(BaseModel):
    id: int
    syndrome: str
    colour: str

    class Config:
        orm_mode = True


class CountryEndpointOutput(BaseModel):
    id: str
    iso3: str
    country_name: str
    lat: float
    long: float
    subregion: str
    region: str

    class Config:
        orm_mode = True


# ================================= Datasets ==================================================
class DatasetOutput(BaseModel):
    id: int
    diseases: str | None
    syndromes: str | None
    location: str
    date: date

    class Config:
        orm_mode = True


class Stats_Params:
    def __init__(
        self,
        start_date: str,
        end_date: str,
        country_id: int,
        lang: Optional[str] = "en",
        disease_ids: Optional[List[int]] = Query(default=[]),
        syndrome_ids: Optional[List[int]] = Query(default=[]),
    ) -> None:
        self.start_date = start_date
        self.end_date = end_date
        self.country_id = country_id
        self.disease_ids = disease_ids
        self.syndrome_ids = syndrome_ids
        self.lang = lang


class TopTenDiseases:
    def __init__(self, start_date: str, end_date: str, country_id: int) -> None:
        self.start_date = start_date
        self.end_date = end_date
        self.country_id = country_id


class TopTenDiseaseOutput(BaseModel):
    id: int
    disease: str
    num: int

    class Config:
        orm_mode = True


class reportIllnessInCountryOutput(BaseModel):
    illness: str
    count: int | None

    class Config:
        orm_mode = True


class reportIllnessInLocation(BaseModel):
    disease_id: int
    disease: str
    count: int


class reportIllnessesInRange(BaseModel):
    date: date
    illness: str
    count: int


class reportIllnessesInRegion(BaseModel):
    illness: str
    count: int


class DateParams(BaseModel):
    start_date: date
    end_date: date


class MapInput:
    def __init__(
        self, start_date: str, end_date: str, country_id: int, disease_list: Optional[List[int]] = Query(default=[]), syndrome_list: Optional[List[int]] = Query(default=[])
    ):
        self.country_id = country_id
        self.start_date = start_date
        self.end_date = end_date
        self.disease_list = disease_list
        self.syndrome_list = syndrome_list


class CountryInput(BaseModel):
    iso3: str
    # country_id: str = Field(..., max_length=3)


## Outputs
class CountryOutput(BaseModel):
    # id = iso3
    id: str
    name: str
    lat: float
    long: float
    subregion: str
    region: str

    class Config:
        orm_mode = True


class countryReportEntry(BaseModel):
    publication_date: str
    title: str
    url: str

    class Config:
        orm_mode = True


class countryReportOutput(BaseModel):
    start_date: str
    end_date: str
    reports: List[countryReportEntry]


class NumReportsPerCountry(BaseModel):
    country_id: int
    country: str
    report_count: int

    class Config:
        orm_mode = True


class MapEndpointInput:
    def __init__(
        self, start_date: str, end_date: str, disease_list: Optional[List[int]] = Query(default=[]), syndrome_list: Optional[List[int]] = Query(default=[]), lang: str | None = "en"
    ) -> None:
        self.start_date = start_date
        self.end_date = end_date
        self.disease_list = disease_list
        self.syndrome_list = syndrome_list
        self.lang = lang


class CountryReportInput:
    def __init__(
        self, start_date: str, end_date: str, country_id: int, disease_list: Optional[List[int]] = Query(default=[]), syndrome_list: Optional[List[int]] = Query(default=[])
    ) -> None:
        self.start_date = start_date
        self.end_date = end_date
        self.country_id = country_id
        self.disease_list = disease_list
        self.syndrome_list = syndrome_list


class MapCountryOutput(BaseModel):
    country: str
    report_count: int
    continent: str
    iso3: str
    lat: float
    long: float
    illness: Dict[str, int]


class MapOutput(BaseModel):
    start_date: str
    end_date: str
    country_list: List[MapCountryOutput]
