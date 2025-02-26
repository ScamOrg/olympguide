from hse_loader.educational_programs_loader.program_loader import parse_educational_programs_with_faculties
from hse_loader.educational_programs_loader.subjects_loader import load_subjects_places_fields
from hse_loader.educational_programs_loader.costs_loader import load_costs_from_first_source, load_costs_from_second_source
from logging_config.setup_logging import setup_logging
import logging

setup_logging()

logger = logging.getLogger(__name__)

def load_programs():
    educational_programs = parse_educational_programs_with_faculties()
    load_costs_from_first_source(programs=educational_programs)
    load_costs_from_second_source(programs=educational_programs)
    load_subjects_places_fields(educational_programs)

