from hse_loader.faculty_loader.faculties_loader import load_faculties
from hse_loader.educational_programs_loader.main import load_programs
from hse_loader.benefits_loader.benefits_parser import load_benefits
from clients.post_client import create_university

create_university(
    name="Национальный исследовательский университет «Высшая школа экономики»",
    email="abitur@hse.ru",
    site="ba.hse.ru",
    region_id=44,
    logo="https://drive.google.com/uc?export=download&id=1UIXzJTDYv2ys_Bq5n_EPiQrRBhfujq1k",
    short_name="ВШЭ"
)

load_faculties(1)
load_programs()
load_benefits()