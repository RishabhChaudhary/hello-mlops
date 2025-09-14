# Variables
UV := uv
PYTHON := $(UV) run python
PROJECT_NAME := hello-mlops

# Default target
.DEFAULT_GOAL := help

# PHONY targets (targets that don't create files)
.PHONY: help install sync run test lint format clean build check dev-setup docker-build docker-run

# Help target - displays available commands
help:
	@echo "Available targets for $(PROJECT_NAME):"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Development Environment Setup
install:
	$(UV) sync

dev-setup: sync
	@echo "Development environment setup complete!"
	@echo "Project: $(PROJECT_NAME)"
	@echo "Python version: $$($(UV) run python --version)"

# Running the application
run:
	$(UV) run main.py

# Testing
test:
	$(UV) run pytest -vv --cov=main --cov-report=html test_main.py

# Code Quality
lint:
	$(UV) run ruff check .

lint-fix:
	$(UV) run ruff check . --fix

format:
	$(UV) run ruff format .

format-check:
	$(UV) run ruff format . --check

# Combined quality checks
check: lint format-check

fix: lint-fix format

update:
	$(UV) sync --upgrade