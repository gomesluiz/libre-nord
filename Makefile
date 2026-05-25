# Define the theme names (matching the folder names in 'themes/')
THEMES = libre-nord-dark libre-nord-light

# Directories for building and output
BUILD_DIR = build
DIST_DIR = dist

# Version resolution from Git tag (strip optional leading 'v')
RAW_VERSION := $(shell git tag --points-at HEAD | head -n1)
VERSION_FROM_TAG := $(patsubst v%,%,$(RAW_VERSION))
DEFAULT_VERSION ?= 0.0.0-dev
STRICT_VERSION ?= 0
VERSION := $(if $(VERSION_FROM_TAG),$(VERSION_FROM_TAG),$(DEFAULT_VERSION))

.PHONY: all clean validate package release changelog check-version $(THEMES)

# The default target runs clean, validate, and packages all themes
all: clean validate package

# Release build requires a tag on HEAD
release: STRICT_VERSION=1
release: clean validate package

changelog:
	@if [ -z "$(NEXT_VERSION)" ]; then \
		echo "error: NEXT_VERSION is required."; \
		echo "usage: make changelog NEXT_VERSION=1.0.5"; \
		exit 1; \
	fi
	@./scripts/update_changelog.sh "$(NEXT_VERSION)" CHANGELOG.md

clean:
	@echo "[INFO] Cleaning old builds and distributions"
	@rm -rf $(BUILD_DIR) $(DIST_DIR)

validate:
	@echo "[INFO] Validating XML file formatting and syntax"
	@command -v xmllint >/dev/null 2>&1 || { echo >&2 "error: xmllint is required."; exit 1; }
	@find . \( -name "*.xml" -o -name "*.xcu" -o -name "*.soc" \) -exec xmllint --noout {} +
	@echo "[INFO] XML validation completed successfully"

package: $(THEMES)

check-version:
	@if [ -z "$(RAW_VERSION)" ] && [ "$(STRICT_VERSION)" = "1" ]; then \
		echo "error: no git tag found on current commit (HEAD)."; \
		echo "hint: create a tag (e.g. v1.0.5) before running 'make release'."; \
		exit 1; \
	fi
	@if [ -z "$(VERSION)" ]; then \
		echo "error: computed VERSION is empty (RAW_VERSION='$(RAW_VERSION)', DEFAULT_VERSION='$(DEFAULT_VERSION)')."; \
		exit 1; \
	fi
	@if [ -z "$(RAW_VERSION)" ]; then \
		echo "[INFO] No tag on HEAD, using fallback version $(VERSION)"; \
	else \
		echo "[INFO] Packaging version $(VERSION) from tag $(RAW_VERSION)"; \
	fi

# Dynamic rule to build each theme independently
$(THEMES): check-version
	@echo "[INFO] Building extension: $@"
	@mkdir -p $(BUILD_DIR)/$@
	@mkdir -p $(DIST_DIR)
	@cp -r shared/* $(BUILD_DIR)/$@/
	@cp -r themes/$@/* $(BUILD_DIR)/$@/
	@sed -E -i 's|(<version value=")[^"]+(" */>)|\1$(VERSION)\2|' $(BUILD_DIR)/$@/description.xml
	@cd $(BUILD_DIR)/$@ && zip -qr ../../$(DIST_DIR)/$@.oxt .
	@echo "[INFO] Generated $@.oxt in $(DIST_DIR)/"