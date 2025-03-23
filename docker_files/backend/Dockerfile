# Use Python 3.9 as base image
FROM python:3.9-alpine

# Set the working directory
WORKDIR /app

# Copy application files from source
COPY source/backend/backend.py .

# Install dependencies
RUN pip install boto3

# Run the backend service
CMD ["python", "backend.py"]