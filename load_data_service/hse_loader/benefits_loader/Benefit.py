class Benefit:
    def __init__(self,
                 olympiad_id: int,
                 program_id: int,
                 is_bvi: bool,
                 min_level: int,
                 min_class: int,
                 confirmation_subjects: list[dict[str: int]],
                 fullscore_subjects: list[int]):
        self.olympiad_id = olympiad_id
        self.program_id = program_id
        self.is_bvi = is_bvi
        self.min_level = min_level
        self.min_class = min_class
        self.confirmation_subjects = confirmation_subjects
        self.fullscore_subjects = fullscore_subjects

    def __str__(self):
        return (f"olympiad_id: {self.olympiad_id}\n"
                f"program_id: {self.program_id}\n"
                f"is_bvi: {self.is_bvi}\n"
                f"min_level: {self.min_level}\n"
                f"min_class: {self.min_class}\n"
                f"confirmation_subjects: {self.confirmation_subjects}\n"
                f"fullscore_subjects: {', '.join(self.fullscore_subjects)}\n\n"
        )