import constants
import redis
import logging
import smtplib
from email.mime.text import MIMEText

redis_client = redis.StrictRedis(host=constants.REDIS_HOST, port=constants.REDIS_PORT, decode_responses=True)

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


def send_code(to_email, code):
    subject = "OlympGuide - одноразовый код"
    body = f"Ваш одноразовый код подтверждения: {code}"

    msg = MIMEText(body)
    msg["Subject"] = subject
    msg["From"] = constants.SMTP_USERNAME
    msg["To"] = to_email

    try:
        with smtplib.SMTP(constants.SMTP_SERVER, constants.SMTP_PORT) as server:
            server.starttls()
            server.login(constants.SMTP_USERNAME, constants.SMTP_PASSWORD)
            server.sendmail(constants.SMTP_USERNAME, to_email, msg.as_string())
        logger.info(f"Email sent to {to_email}")
    except Exception as e:
        logger.error(f"Failed to send email: {e}")


def process_message(topic, message):
    data = eval(message)
    if topic == "email_codes":
        send_code(data["email"], data["code"])
    else:
        logger.warning(f"Unknown topic: {topic}")


def process_redis_messages():
    logger.info("Listening for messages...")
    pubsub = redis_client.pubsub()
    pubsub.subscribe(constants.REDIS_TOPICS)

    for message in pubsub.listen():
        if message['type'] == 'message':
            topic = message['channel']
            message_data = message['data']
            logger.info(f"Received message from {topic}: {message_data}")
            process_message(topic, message_data)


if __name__ == "__main__":
    process_redis_messages()
