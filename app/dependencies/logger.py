import datetime
import logging
import sys
import time
from os import path


def get_logger(logname: str = "api"):
    file_name_str = "{0}-{1:%Y-%m-%d}.log.txt".format(logname, datetime.datetime.utcnow())
    if logging.getLogger(file_name_str).hasHandlers():
        return logging.getLogger(file_name_str)
    logger = logging.getLogger(file_name_str)

    script_path = path.abspath(__file__)
    script_directory = str(path.dirname(path.dirname(script_path)))

    full_filename = path.join(script_directory, "logs", file_name_str)
    formatStr = "%(asctime)s %(levelname)s [%(filename)s:%(lineno)s-%(funcName)10s() ]: --  %(message)s"
    file_handler = logging.FileHandler(full_filename, mode="a")
    loggingFormatter = logging.Formatter(formatStr)
    loggingFormatter.converter = time.gmtime
    file_handler.setFormatter(loggingFormatter)

    stdout_handler = logging.StreamHandler(sys.stdout)
    stdout_handler.setFormatter(loggingFormatter)

    logger.addHandler(stdout_handler)
    logger.addHandler(file_handler)

    logger.setLevel(logging.DEBUG)
    logger.info("Logger Created: " + logger.name)
    return logger
