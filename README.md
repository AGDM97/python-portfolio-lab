# python-portfolio-lab

My Python engineering lab: best practices, CI, tests, and small projects.

## Run locally

```bash
python -m venv .venv
source .venv/bin/activate
pip install -U pip
pip install -e ".[dev]"

python -m portfolio_lab.main
pytest
ruff check .
ruff format .
mypy src


### 10.5) `pyproject.toml`
```bash
cat > pyproject.toml << 'EOF'
[project]
name = "portfolio-lab"
version = "0.1.0"
description = "Python engineering portfolio lab"
readme = "README.md"
requires-python = ">=3.12"
dependencies = []

[project.optional-dependencies]
dev = [
  "pytest>=8.0",
  "ruff>=0.6",
  "mypy>=1.8",
]

[tool.pytest.ini_options]
testpaths = ["tests"]

[tool.ruff]
line-length = 100
target-version = "py312"

[tool.ruff.lint]
select = ["E", "F", "I", "B", "UP"]

[tool.mypy]
python_version = "3.12"
strict = true
warn_unused_configs = true
mypy_path = "src"
