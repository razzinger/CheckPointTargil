import boto3
import json
import os
from flask import Flask, request, jsonify

app = Flask(__name__)

# AWS Configuration
AWS_REGION  = "eu-north-1"
EXEC_VALUES = "sqs-s3-secrets-FRos9"


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


# Initialize SQS Client
sqs_client = boto3.client("sqs", region_name=AWS_REGION)

@app.route("/", methods=["GET"])
def health_check():
    return "OK", 200

@app.route("/receive", methods=["POST"])
def receive_data():
    # Load secrets
    secrets = get_secret(EXEC_VALUES)
    print(f"Secrets: {secrets}")

    if not secrets or "VALID_TOKEN" not in secrets or "SQS_QUEUE_URL" not in secrets:
        return jsonify({"error": "Failed to load secrets from AWS Secrets Manager"}), 500

    TOKEN         = secrets.get("VALID_TOKEN")
    SQS_QUEUE_URL = secrets.get("SQS_QUEUE_URL")

    #Parse JSON data
    data = request.get_json()
    if not data:
        return jsonify({"error": "Invalid JSON format"}), 400
    
    received_token = data.get("token")
    if received_token != TOKEN:
        return jsonify({"error": "Unauthorized: Invalid token"}), 401

    # Send message to SQS
    try:
        response = sqs_client.send_message(
            QueueUrl=SQS_QUEUE_URL,
            MessageBody=json.dumps(data)
        )
        return jsonify({"message": "Data sent to SQS", "message_id": response["MessageId"]}), 200
    except Exception as e:
        print(f"Error sending message to SQS: {e}")
        return jsonify({"error": "Failed to send message to SQS"}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8081)
