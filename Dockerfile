# 1) Base image
FROM python:3.11-slim

# 2) System setup
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# 3) Workdir
WORKDIR /app

# 4) Install deps first (better cache)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5) Copy app code
COPY . .

# 6) (Optional) run as non-root for safety
RUN useradd -m appuser
USER appuser

# 7) Expose app port and start
EXPOSE 8000
CMD ["python", "app.py"]

