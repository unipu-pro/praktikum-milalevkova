ARG PYTHON_IMAGE=python:3.13-alpine

# Base stage: runtime dependencies
FROM ${PYTHON_IMAGE} AS base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt


# Test stage: install development dependencies and run tests
FROM base AS test

COPY requirements-dev.txt .

RUN pip install --no-cache-dir -r requirements-dev.txt

COPY version.txt ollama_client.py llm.py ./
COPY tests/ tests/

RUN python -m pytest -v


# Runtime stage: minimal production image
FROM base AS runtime

RUN adduser -D -u 10001 app

COPY version.txt ollama_client.py llm.py ./

USER app

ENTRYPOINT ["python", "llm.py"]
CMD ["--help"]
