# DataCivicLab — Bilancio dello Stato
# CLI toolkit del Lab. La memoria DuckDB è controllata da safe_connect
# (lab-connectors) via env DUCKDB_MEMORY_LIMIT (default 2GB).
TOOLKIT = toolkit

DATASETS := $(shell find datasets -name dataset.yml 2>/dev/null | sort)
SUPPORT  := $(shell find support -name dataset.yml 2>/dev/null | sort)

.PHONY: seeds
seeds:
	@for f in $(SUPPORT); do \
		echo "=== $$f ==="; \
		$(TOOLKIT) run --config "$$f" || exit 1; \
	done

.PHONY: run
run:
	@for f in $(DATASETS); do \
		echo "=== $$f ==="; \
		$(TOOLKIT) run --config "$$f" || exit 1; \
	done

.PHONY: run-all
run-all: seeds run

.PHONY: check
check:
	@for f in $(SUPPORT) $(DATASETS); do \
		echo "→ $$f"; \
		$(TOOLKIT) run preflight --config "$$f" > /dev/null 2>&1 || exit 1; \
	done
	@echo "✅ All configs valid"

.PHONY: clean
clean:
	rm -rf out/data/_runs out/data/probe out/data/raw out/data/clean out/data/mart out/data/cross .tmp/

.PHONY: clean-runs
clean-runs:
	rm -rf out/data/_runs/

.PHONY: registry registry-write
registry:
	$(TOOLKIT) registry build

registry-write:
	$(TOOLKIT) registry build --write

.PHONY: test
test:
	pytest tests/ -v

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:' Makefile | sort
