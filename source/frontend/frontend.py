import boto3
import json
import os
from flask import Flask, request, jsonify

app = Flask(__name__)

# AWS Configuration
AWS_REGION  = "eu-north-1"
EXEC_VALUES = "my-run-values"


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
    auth_header = request.headers.get("Authorization")

    # Load secrets
    secrets = get_secret(EXEC_VALUES)

    if secrets:
        TOKEN         = secrets["VALID_TOKEN"]
        SQS_QUEUE_URL = secrets["SQS_QUEUE_URL"]
    else:
        raise ValueError("Failed to load secrets from AWS Secrets Manager")
    
    if not auth_header or not auth_header.startswith("Bearer ") or auth_header.split(" ")[1] != TOKEN:
        return jsonify({"error": "Unauthorized"}), 401

    data = request.get_json()
    if not data:
        return jsonify({"error": "Invalid JSON"}), 400

    # Send message to SQS
    try:
        response = sqs_client.send_message(
            QueueUrl=SQS_QUEUE_URL,
            MessageBody=json.dumps(data)
        )
        return jsonify({"message": "Data sent to SQS", "message_id": response["MessageId"]}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8081)
