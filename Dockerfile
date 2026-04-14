# Use the official Playwright Python image as base
# This image contains all system dependencies for Chromium, Firefox, and WebKit
FROM mcr.microsoft.com/playwright/python:v1.40.0-jammy

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    # Force enrich to use 256 colors
    TERM=xterm-256color \
    # Ensure UTF-8 encoding for Rich/TUI output
    PYTHONIOENCODING=utf-8

# Set working directory
WORKDIR /app

# Install system dependencies for any other tools (if needed)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libgbm-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Install Playwright browser binaries (specifically chromium for stealth)
RUN playwright install chromium

# Create a non-root user for security
RUN useradd -m -u 1000 pwuser && \
    chown -R pwuser:pwuser /app

# Create persistent storage directories and set permissions
RUN mkdir -p config logs credentials output && \
    chown -R pwuser:pwuser config logs credentials output

# Switch to the non-root user
USER pwuser

# Copy the application code
COPY --chown=pwuser:pwuser . .

# Set default command
# Note: Use -it when running to interact with the TUI
CMD ["python", "main.py"]
