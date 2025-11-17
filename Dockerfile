# Use official Python 3.9 base image
FROM python:3.9

# Set working directory inside container
WORKDIR /app

# Copy requirements first (so we can use Docker cache)
COPY requirements.txt /app/

# Install system dependencies (mysqlclient needs them)
RUN apt-get update \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy full Django project code
COPY . /app/

# Expose port 8000 (Django default)
EXPOSE 8000

# Collect static files
RUN python3 manage.py collectstatic --noinput

# Run migrations and then start server (here using Django’s dev server)
CMD ["bash", "-c", "python3 manage.py migrate && python3 manage.py runserver 0.0.0.0:8000"]
