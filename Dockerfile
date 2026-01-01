# ---- builder: download/build wheels (including deps) ----
FROM python:3.12-slim AS builder

WORKDIR /app
RUN pip install -U pip

COPY pyproject.toml README.md /app/
COPY src /app/src

# Build wheels for the project + runtime deps
RUN pip wheel --no-cache-dir --wheel-dir /wheels .

# ---- runtime: install only wheels (no build tools, no caches) ----
FROM python:3.12-slim AS runtime

WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY --from=builder /wheels /wheels

RUN pip install --no-cache-dir --no-index --find-links=/wheels portfolio-lab \
    && rm -rf /wheels

EXPOSE 8000
CMD ["uvicorn", "portfolio_api.app:app", "--host", "0.0.0.0", "--port", "8000"]
