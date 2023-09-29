from sqlalchemy import TIMESTAMP, BigInteger, Column, DateTime, Float, ForeignKey, Integer, SmallInteger, String, Text, UniqueConstraint, func
from sqlalchemy.orm import DeclarativeBase
from sqlalchemy.sql import text


class Base(DeclarativeBase):
    pass


class Subregions(Base):
    __tablename__ = "subregions"
    id = Column(Integer, primary_key=True, unique=True)
    subregion = Column(String(50), nullable=False)
    iso3 = Column(String(3), nullable=False, unique=True)



class Regions(Base):
    __tablename__ = "regions"
    id = Column(Integer, primary_key=True, unique=True)
    region = Column(String(50), nullable=False)
    iso3 = Column(String(3), nullable=False, unique=True)



class ColoursApi(Base):
    __tablename__ = "colours_api"

    id = Column(Integer, primary_key=True)
    color_hex = Column(String(8))


class Disease(Base):
    __tablename__ = "disease"

    id = Column(Integer, primary_key=True, autoincrement=True, unique=True, nullable=False)
    disease = Column(String(100), nullable=False, unique=True)
    active = Column(SmallInteger, nullable=False, default=1)
    last_updated = Column(TIMESTAMP, nullable=False, server_default=text("CURRENT_TIMESTAMP"))


class Syndrome(Base):
    __tablename__ = "syndrome"
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    syndrome = Column(String(100), nullable=False, unique=True)
    active = Column(SmallInteger, nullable=False, default=True)
    last_updated = Column(DateTime, nullable=False, server_default="CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP")
    __table_args__ = (UniqueConstraint("id"),)


class Report(Base):
    __tablename__ = "report"

    id = Column(Integer, primary_key=True)
    article_id = Column(Integer, ForeignKey("article.id"), nullable=False)
    last_updated = Column(TIMESTAMP, nullable=False, server_default=func.now(), onupdate=func.now())


class ReportDataPointSyndrome(Base):
    __tablename__ = "report_data_point_syndrome"
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    report_id = Column(BigInteger, ForeignKey("report.id"), nullable=False)
    syndrome_id = Column(BigInteger, ForeignKey("syndrome.id"), nullable=False)
    __table_args__ = (
        UniqueConstraint("id"),
        UniqueConstraint("report_id", "syndrome_id"),
        {"mysql_charset": "utf8mb4"},
    )


class ReportDataPointDisease(Base):
    __tablename__ = "report_data_point_disease"
    id = Column(Integer, primary_key=True, autoincrement=True)
    report_id = Column(Integer, ForeignKey("report.id"), nullable=False)
    disease_id = Column(Integer, ForeignKey("disease.id"), nullable=False)

    UniqueConstraint("report_id", "disease_id", name="report_id")


class CountryData(Base):
    __tablename__ = "country_data"

    id = Column(Integer, primary_key=True, autoincrement=True, unique=True, nullable=False)
    country_name = Column(String(50), nullable=False)
    iso3 = Column(String(3), nullable=False, unique=True)
    iso2 = Column(String(2), nullable=True, default=None)
    latitude = Column(Float(), nullable=False)
    longitude = Column(Float(), nullable=False)
    last_updated = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))


class ReportDataPointLocation(Base):
    __tablename__ = "report_data_point_location"
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    report_id = Column(BigInteger, ForeignKey("report.id"), nullable=False)
    latitude = Column(Float())
    longitude = Column(Float())
    district = Column(Text)
    city = Column(Text)
    metro_area = Column(Text)
    sub_region = Column(Text)
    region = Column(Text)
    country_id = Column(BigInteger, ForeignKey("country_data.id"), nullable=False)

    __table_args__ = (
        UniqueConstraint("id"),
        UniqueConstraint("report_id"),
        {"mysql_charset": "utf8mb4"},
    )


class ReportDataFieldType(Base):
    __tablename__ = "report_data_field_type"
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100), nullable=False)
    description = Column(String(512), nullable=False)
    last_updated = Column(TIMESTAMP, nullable=False, server_default=text("CURRENT_TIMESTAMP"), onupdate=text("CURRENT_TIMESTAMP"))


class ReportDataField(Base):
    __tablename__ = "report_data_field"

    id = Column(Integer, primary_key=True, autoincrement=True, unique=True)
    name = Column(String(100), nullable=False)
    description = Column(String(512), nullable=False)
    report_data_field_type_id = Column(Integer, ForeignKey("report_data_field_type.id"), nullable=False)
    last_updated = Column(DateTime, server_default=text("CURRENT_TIMESTAMP"), onupdate=text("CURRENT_TIMESTAMP"))

    __table_args__ = (
        UniqueConstraint("id"),
        UniqueConstraint("name"),
    )


class ReportDataPoint(Base):
    __tablename__ = "report_data_point"
    id = Column(Integer, primary_key=True, autoincrement=True)
    report_id = Column(Integer, ForeignKey("report.id", ondelete="RESTRICT", onupdate="CASCADE"))
    report_data_field_id = Column(Integer, ForeignKey("report_data_field.id", ondelete="RESTRICT", onupdate="CASCADE"))
    value = Column(String, nullable=False)
    UniqueConstraint("report_id", "report_data_field_id", name="report_id")
