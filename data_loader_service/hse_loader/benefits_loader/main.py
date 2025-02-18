from logging_config.setup_logging import setup_logging
import logging
from clients.get_client import get_olympiads
setup_logging()

olympiads = get_olympiads()
print('московская олимпиада школьников' in olympiads)