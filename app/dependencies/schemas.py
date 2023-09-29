from typing import List

from pydantic import BaseModel


# ================================= STATIC SCHEMAS ===============================================
class Disease(BaseModel):
    id: int
    disease: str
    active: bool
    colour: str


class DiseaseObject(BaseModel):
    result: List[Disease]


class Syndrome(BaseModel):
    id: int
    syndrome: str
    active: bool
    colour: str


class SyndromeObject(BaseModel):
    result: List[Syndrome]


### INPUTS ###
class CountryInput(BaseModel):
    iso3: str


## Outputs
class CountryOutput(BaseModel):
    id: str
    name: str
    lat: float
    long: float
    subregion: str
    region: str

    class Config:
        orm_mode = True







