import os

REDIS_HOST = os.getenv("REDIS_HOST")
REDIS_PORT = int(os.getenv("REDIS_PORT"))
EMAIL_CODE_TOPIC = "auth.email.code"
REDIS_TOPICS = [EMAIL_CODE_TOPIC]

SMTP_SERVER = "smtp.mail.ru"
SMTP_PORT = 587
SMTP_USERNAME = os.getenv("SMTP_USERNAME")
SMTP_PASSWORD = os.getenv("SMTP_PASSWORD")