# Define the theme names (matching the folder names in 'themes/')
THEMES = libre-nord-dark libre-nord-light

# Directories for building and output
BUILD_DIR = build
DIST_DIR = dist

.PHONY: all clean validate package $(THEMES)

# The default target runs clean, validate, and packages all themes
all: clean validate package

clean:
	@echo "[INFO] Cleaning old builds and distributions"
	@rm -rf $(BUILD_DIR) $(DIST_DIR)

validate:
	@echo "[INFO] Validating XML file formatting and syntax"
	@command -v xmllint >/dev/null 2>&1 || { echo >&2 "error: xmllint is required."; exit 1; }
	@find . \( -name "*.xml" -o -name "*.xcu" -o -name "*.soc" \) -exec xmllint --noout {} +
	@echo "[INFO] XML validation completed successfully"

package: $(THEMES)

# Dynamic rule to build each theme independently
$(THEMES):
	@echo "[INFO] Building extension: $@"
	@mkdir -p $(BUILD_DIR)/$@
	@mkdir -p $(DIST_DIR)
	@cp -r shared/* $(BUILD_DIR)/$@/
	@cp -r themes/$@/* $(BUILD_DIR)/$@/
	@cd $(BUILD_DIR)/$@ && zip -qr ../../$(DIST_DIR)/$@.oxt .
	@echo "[INFO] Generated $@.oxt in $(DIST_DIR)/"