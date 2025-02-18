import logging

class ColoredFormatter(logging.Formatter):
    COLORS = {'DEBUG': '\033[92m', 'INFO': '\033[94m', 'WARNING': '\033[93m',
              'ERROR': '\033[91m', 'CRITICAL': '\033[95m'}

    def format(self, record):
        log_fmt = (f"{self.COLORS.get(record.levelname, '')}"
                   f"%(asctime)s - %(name)s - %(levelname)s - %(message)s\033[0m")
        formatter = logging.Formatter(log_fmt)
        return formatter.format(record)
