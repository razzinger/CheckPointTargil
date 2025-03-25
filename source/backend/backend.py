import boto3
import json
import os
import threading
from datetime import datetime
from flask import Flask

# AWS Configuration
AWS_REGION  = "eu-north-1"
EXEC_VALUES = "sqs-s3-secrets-FRos9"

app = Flask(__name__)

def get_secret(secret_name):
    """Fetch secret from AWS Secrets Manager"""
    session = boto3.session.Session()
    client = session.client(service_name="secretsmanager", region_name=AWS_REGION)

    try:
        response = client.get_secret_value(SecretId=secret_name)
        return json.loads(response["SecretString"])
    except Exception as e:
        print(f"Error retrieving secret: {e}")
        return None


# Load secrets
secrets = get_secret(EXEC_VALUES)
if not secrets or "S3_BUCKET_NAME" not in secrets or "SQS_QUEUE_URL" not in secrets:
    raise ValueError("Failed to load secrets from AWS Secrets Manager")

SQS_QUEUE_URL  = secrets["SQS_QUEUE_URL"]
S3_BUCKET_NAME = secrets["S3_BUCKET_NAME"]

# Initialize AWS Objects
SQS_OBJECT = boto3.client("sqs", region_name=AWS_REGION)
S3_OBJECT  = boto3.client("s3", region_name=AWS_REGION)


def receive_messages():
    response = SQS_OBJECT.receive_message(
        QueueUrl=SQS_QUEUE_URL,
        MaxNumberOfMessages=10,
        WaitTimeSeconds=10
    )
    return response.get("Messages", [])

def store_message_to_s3(message):
    timestamp = datetime.utcnow().strftime("%Y-%m-%d_%H-%M-%S-%f")
    file_name = f"sqs_message_{timestamp}.json"
    file_content = json.dumps(message, indent=4)
    
    S3_OBJECT.put_object(
        Bucket=S3_BUCKET_NAME,
        Key=file_name,
        Body=file_content
    )
    print(f"Stored message in S3: {file_name}")

def delete_message_from_sqs(receipt_handle):
    SQS_OBJECT.delete_message(
        QueueUrl=SQS_QUEUE_URL,
        ReceiptHandle=receipt_handle
    )
    print("Deleted message from SQS")

def process_messages():
    while True:
        messages = receive_messages()
        for message in messages:
            store_message_to_s3(message["Body"])
            delete_message_from_sqs(message["ReceiptHandle"])

# Health check
@app.route("/", methods=["GET"])
def health_check():
    return "OK", 200

def start_flask():
    app.run(host="0.0.0.0", port=8081)

if __name__ == "__main__":
    threading.Thread(target=start_flask, daemon=True).start()
    process_messages()
