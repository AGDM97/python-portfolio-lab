# python-portfolio-lab

My Python engineering lab: best practices, CI, tests, and small projects.

## Setup

```bash
python -m venv .venv
source .venv/bin/activate
pip install -U pip
pip install -e ".[dev]"
pre-commit install
```

## Run

```bash
python -m portfolio_lab.main
python -m portfolio_lab.main --name Angelo
```

## Quality checks

```bash
pytest
ruff check .
ruff format .
mypy src
pre-commit run --all-files
```
