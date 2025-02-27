class Benefit:
    def __init__(self,
                 olympiad_id: int,
                 program_id: int,
                 is_bvi: bool,
                 min_diploma_level: int,
                 min_class: int,
                 confirmation_subjects: list[dict[str: int]],
                 full_score_subjects: list[int]):
        self.olympiad_id = olympiad_id
        self.program_id = program_id
        self.is_bvi = is_bvi
        self.min_diploma_level = min_diploma_level
        self.min_class = min_class
        self.confirmation_subjects = confirmation_subjects
        self.full_score_subjects = full_score_subjects

    def __str__(self):
        return (f"olympiad_id: {self.olympiad_id}\n"
                f"program_id: {self.program_id}\n"
                f"is_bvi: {self.is_bvi}\n"
                f"min_level: {self.min_diploma_level}\n"
                f"min_class: {self.min_class}\n"
                f"confirmation_subjects: {self.confirmation_subjects}\n"
                f"full_score_subjects: {self.full_score_subjects}\n\n"
        )

    def __eq__(self, other):
        if self.olympiad_id == other.olympiad_id:
            if self.program_id == other.program_id:
                if self.min_class == other.min_class:
                    if self.min_diploma_level == other.min_diploma_level:
                        return True
        return False