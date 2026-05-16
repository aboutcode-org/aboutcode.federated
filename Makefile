#
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) nexB Inc. and contributors
# See https://github.com/aboutcode-org/aboutcode.federated/ for support and sources

# Python version can be specified with `$ PYTHON_EXE=python3.x make conf`
PYTHON_EXE?=python3
VENV=venv
ACTIVATE?=. ${VENV}/bin/activate;

virtualenv:
	@echo "-> Bootstrap the virtualenv with PYTHON_EXE=${PYTHON_EXE}"
	@${PYTHON_EXE} -m venv ${VENV}
	@${ACTIVATE} pip install --upgrade pip

conf: virtualenv
	@echo "-> Install dependencies"
	@${ACTIVATE} pip install --editable .

dev: virtualenv
	@echo "-> Configure and install development dependencies"
	@${ACTIVATE} pip install --editable .[dev]

build: test
	@echo "-> Building sdist and wheel"
	rm -rf build/ dist/
	${VENV}/bin/flot --pyproject pyproject.toml --sdist --wheel

publish: build
	@echo "-> Publish built sdist and wheel to PyPi"
	${VENV}/bin/twine upload dist/*

doc8:
	@echo "-> Run doc8 validation"
	@${ACTIVATE} doc8 --quiet docs/ *.rst

valid:
	@echo "-> Run Ruff format"
	@${ACTIVATE} ruff format
	@echo "-> Run Ruff linter"
	@${ACTIVATE} ruff check --fix

check:
	@echo "-> Run Ruff linter validation (pycodestyle, bandit, isort, and more)"
	@${ACTIVATE} ruff check
	@echo "-> Run Ruff format validation"
	@${ACTIVATE} ruff format --check
	@$(MAKE) doc8

clean:
	@echo "-> Clean the Python env"
	rm -rf ${VENV} build/ dist/ docs/_build/ pip-selfcheck.json .tox .pytest_cache/ .coverage
	find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete

test: check
	@echo "-> Run the test suite"
	${ACTIVATE} ${PYTHON_EXE} -m pytest -vvs

bump:
	@echo "-> Bump the version"
	venv/bin/bump-my-version bump patch

docs:
	rm -rf docs/_build/
	@${ACTIVATE} sphinx-build docs/source docs/_build/

docs-check:
	@${ACTIVATE} sphinx-build -E -W -b html docs/source docs/_build/
	@${ACTIVATE} sphinx-build -E -W -b linkcheck docs/source docs/_build/

.PHONY: virtualenv conf dev build publish doc8 valid check clean test bump docs docs-check
