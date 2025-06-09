FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements and install them first (layer caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code including templates and static folders
COPY . .

# Set environment variables (optional)
ENV PYTHONUNBUFFERED=1

# Run Flask app
CMD ["python", "app.py"]
