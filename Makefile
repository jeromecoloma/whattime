# WhatTime — Build Automation
SHELL := /bin/zsh
ROOT_DIR := $(shell pwd)
SCRIPTS_DIR := $(ROOT_DIR)/scripts

.PHONY: help setup xcodeproj build run clean lint lint-fix format format-check test archive install-hooks

help:
	@echo ""
	@echo "WhatTime build targets:"
	@echo ""
	@echo "  make setup          First-run setup: install deps, hooks, generate .xcodeproj, build"
	@echo "  make install-hooks  Install git hooks (pre-push lint + format check)"
	@echo "  make xcodeproj      Regenerate .xcodeproj from project.yml"
	@echo "  make build          Build the app (Debug)"
	@echo "  make run            Build and launch the app"
	@echo "  make clean          Remove derived data and dist artifacts"
	@echo "  make lint           Run SwiftLint"
	@echo "  make lint-fix       Run SwiftLint with autocorrect"
	@echo "  make format         Format source files with SwiftFormat"
	@echo "  make format-check   Dry-run format check (no changes)"
	@echo "  make test           Run unit tests"
	@echo "  make archive        Build a release archive"
	@echo ""

setup:
	@$(SCRIPTS_DIR)/setup.sh

install-hooks:
	@$(SCRIPTS_DIR)/install-hooks.sh

xcodeproj:
	@$(SCRIPTS_DIR)/xcodeproj.sh

build:
	@$(SCRIPTS_DIR)/build.sh

run:
	@$(SCRIPTS_DIR)/run.sh

clean:
	@$(SCRIPTS_DIR)/clean.sh

lint:
	@$(SCRIPTS_DIR)/lint.sh

lint-fix:
	@$(SCRIPTS_DIR)/lint.sh --fix

format:
	@$(SCRIPTS_DIR)/format.sh --format

format-check:
	@$(SCRIPTS_DIR)/format.sh --check

test:
	@$(SCRIPTS_DIR)/test.sh

archive:
	@$(SCRIPTS_DIR)/archive.sh
