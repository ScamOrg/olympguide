import logging
import sys
from logging_config.ColoredFormatter import ColoredFormatter

def setup_logging():
    log_format = ""

    logging.basicConfig(
        level=logging.DEBUG,
        format=log_format,
        handlers=[
            logging.StreamHandler(sys.stdout),
            # logging.FileHandler("app.log", encoding="utf-8")
        ]
    )

    logging.getLogger().handlers[0].setFormatter(ColoredFormatter())

    logging.getLogger("pdfminer").setLevel(logging.WARNING)
