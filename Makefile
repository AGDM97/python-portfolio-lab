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

docker-health:
	docker compose up -d --build
	@echo "Waiting for container health..."
	@for i in 1 2 3 4 5 6 7 8 9 10 11 12; do \
	  status=$$(docker inspect --format='{{.State.Health.Status}}' $$(docker compose ps -q api) 2>/dev/null || echo "unknown"); \
	  echo "health=$$status"; \
	  if [ "$$status" = "healthy" ]; then exit 0; fi; \
	  sleep 2; \
	done; \
	echo "Container did not become healthy"; \
	docker compose logs --tail 50 api; \
	exit 1

api:
	$(UVICORN) portfolio_api.app:app --host 0.0.0.0 --port 8000 --reload
