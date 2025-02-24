from program_loader import parse_educational_programs_with_faculties
from subjects_loader import load_subjects_places_fields
from costs_loader import load_costs_from_first_source, load_costs_from_second_source
from logging_config.setup_logging import setup_logging
import logging

setup_logging()

logger = logging.getLogger(__name__)

def main():
    educational_programs = parse_educational_programs_with_faculties()
    load_costs_from_first_source(programs=educational_programs)
    load_costs_from_second_source(programs=educational_programs)
    load_subjects_places_fields(educational_programs)

if __name__ == '__main__':
    main()
