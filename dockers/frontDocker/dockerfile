# Use Python 3.9 as base image
FROM python:3.9

# Set the working directory
WORKDIR /app

# Copy application files from source
COPY ../../source/frontApp/frontend.py .

# Install dependencies
RUN pip install flask boto3

# Expose the application port
EXPOSE 5000

# Run the frontend service
CMD ["python", "frontend.py"]