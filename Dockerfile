FROM python:3.12-slim

WORKDIR /app

RUN pip install -U pip

COPY pyproject.toml README.md /app/
COPY src /app/src

RUN pip install -e ".[dev]"

EXPOSE 8000
CMD ["uvicorn", "portfolio_api.app:app", "--host", "0.0.0.0", "--port", "8000"]
