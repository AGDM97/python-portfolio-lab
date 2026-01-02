VENV ?= .venv
PYTHON ?= python3

PY := $(VENV)/bin/python
PIP := $(VENV)/bin/pip
RUFF := $(VENV)/bin/ruff
MYPY := $(VENV)/bin/mypy
PRECOMMIT := $(VENV)/bin/pre-commit
UVICORN := $(VENV)/bin/uvicorn

.PHONY: help venv install precommit test lint format typecheck check docker-up docker-down docker-logs docker-rebuild api

help:
	@echo "Targets:"
	@echo "  venv           - Create virtualenv at .venv (if missing)"
	@echo "  install        - Install deps into .venv (editable)"
	@echo "  precommit      - Run pre-commit on all files"
	@echo "  test           - Run pytest"
	@echo "  lint           - Run ruff check"
	@echo "  format         - Run ruff format"
	@echo "  typecheck      - Run mypy"
	@echo "  check          - Run test + lint + format check + typecheck + precommit"
	@echo "  docker-up      - Build and start docker compose"
	@echo "  docker-down    - Stop docker compose"
	@echo "  docker-logs    - Tail API logs"
	@echo "  docker-rebuild - Rebuild without cache and start"
	@echo "  api            - Run API locally with uvicorn"

venv:
	@test -d $(VENV) || $(PYTHON) -m venv $(VENV)

install: venv
	$(PY) -m pip install -U pip
	$(PIP) install -e ".[dev]"

precommit:
	$(PRECOMMIT) run --all-files

test:
	$(PY) -m pytest

lint:
	$(RUFF) check .

format:
	$(RUFF) format .

typecheck:
	$(MYPY) src

check: test lint
	$(RUFF) format --check .
	$(MAKE) typecheck
	$(MAKE) precommit

docker-up:
	docker compose up -d --build

docker-down:
	docker compose down

docker-logs:
	docker compose logs -f --tail 50 api

docker-rebuild:
	docker compose build --no-cache
	docker compose up -d

api:
	$(UVICORN) portfolio_api.app:app --host 0.0.0.0 --port 8000 --reload
