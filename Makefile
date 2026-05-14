# Define the theme names (matching the folder names in 'themes/')
THEMES = libre-nord-polar libre-nord-snow libre-nord-frost libre-nord-aurora

# Directories for building and output
BUILD_DIR = build
DIST_DIR = dist

.PHONY: all clean validate package $(THEMES)

# The default target runs clean, validate, and packages all themes
all: clean validate package

clean:
	@echo "==> Cleaning old builds and distributions..."
	rm -rf $(BUILD_DIR) $(DIST_DIR)

validate:
	@echo "==> Validating the formatting and syntax of all XML files..."
	@command -v xmllint >/dev/null 2>&1 || { echo >&2 "Error: xmllint is required."; exit 1; }
	find . \( -name "*.xml" -o -name "*.xcu" -o -name "*.soc" \) -exec xmllint --noout {} +
	@echo "==> All XML files are valid!"

package: $(THEMES)

# Dynamic rule to build each theme independently
$(THEMES):
	@echo "==> Building extension: $@..."
	@mkdir -p $(BUILD_DIR)/$@
	@mkdir -p $(DIST_DIR)
	# Copy shared core files
	@cp -r shared/* $(BUILD_DIR)/$@/
	# Copy specific theme configurations
	@cp -r themes/$@/* $(BUILD_DIR)/$@/
	# Package into an .oxt file
	@cd $(BUILD_DIR)/$@ && zip -qr ../../$(DIST_DIR)/$@.oxt .
	@echo "==> $@.oxt generated successfully in $(DIST_DIR)/"