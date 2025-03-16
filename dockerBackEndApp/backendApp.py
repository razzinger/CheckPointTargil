import boto3
import json
import os
from datetime import datetime

# AWS Configuration
AWS_REGION = "your-region"  # e.g., "us-east-1"
SQS_VALUES = "my-sqs-values"


def get_secret(secret_name):
    """Fetch secret from AWS Secrets Manager"""
    session = boto3.session.Session()
    client  = session.client(service_name="secretsmanager", region_name=AWS_REGION)

    try:
        response = client.get_secret_value(SecretId=secret_name)
        return json.loads(response["SecretString"])
    except Exception as e:
        print(f"Error retrieving secret: {e}")
        return None


# Load secrets
secrets = get_secret(SQS_VALUES)

if secrets:    
    SQS_QUEUE_URL  = secrets["SQS_QUEUE_URL"]
    S3_BUCKET_NAME = secrets["S3_BUCKET_NAME"]
else:
    raise ValueError("Failed to load secrets from AWS Secrets Manager")

# Initialize AWS Clients
sqs = boto3.client("sqs", region_name=AWS_REGION)
s3  = boto3.client("s3", region_name=AWS_REGION)

def receive_messages():
    response = sqs.receive_message(
        QueueUrl=SQS_QUEUE_URL,
        MaxNumberOfMessages=10,  # Adjust based on your need
        WaitTimeSeconds=10  # Long polling to reduce empty responses
    )
    return response.get("Messages", [])

def store_message_to_s3(message):
    timestamp = datetime.utcnow().strftime("%Y-%m-%d_%H-%M-%S-%f")
    file_name = f"sqs_message_{timestamp}.json"
    file_content = json.dumps(message, indent=4)
    
    s3.put_object(
        Bucket=S3_BUCKET_NAME,
        Key=file_name,
        Body=file_content
    )
    print(f"Stored message in S3: {file_name}")

def delete_message_from_sqs(receipt_handle):
    sqs.delete_message(
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

if __name__ == "__main__":
    process_messages()
