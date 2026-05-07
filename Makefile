EXT_NAME = libre-nord
VERSION = 1.0.0
OXT = $(EXT_NAME)-$(VERSION).oxt

# Separação segura por extensão
XML_FILES = $(shell find . -name "*.xml" -o -name "*.xcu" ! -path "./.github/*")
JSON_FILES = $(shell find . -name "*.json" ! -path "./.github/*")

.PHONY: all validate generate-icons package clean install check-deps

all: package

# Verifica dependências do sistema
check-deps:
	@command -v xmllint >/dev/null 2>&1 || { echo "❌ 'xmllint' não encontrado."; echo "   -> Ubuntu/Debian: sudo apt install libxml2-utils"; echo "   -> macOS: brew install libxml2"; exit 1; }
	@command -v python3 >/dev/null 2>&1 || { echo "❌ 'python3' não encontrado. Instale o Python 3."; exit 1; }
	@command -v zip >/dev/null 2>&1 || { echo "❌ 'zip' não encontrado. Instale o utilitário zip."; exit 1; }

validate: check-deps
	@echo "🔍 Validando XML/XCU..."
	@if [ -n "$(XML_FILES)" ]; then \
		xmllint --noout $(XML_FILES) || { echo "❌ Erro de sintaxe em XML/XCU"; exit 1; }; \
	else \
		echo "ℹ️ Nenhum arquivo XML/XCU encontrado"; \
	fi
	@echo " Validando JSON..."
	@if [ -n "$(JSON_FILES)" ]; then \
		python3 -m json.tool $(JSON_FILES) > /dev/null || { echo "❌ Erro de sintaxe em JSON"; exit 1; }; \
	else \
		echo "ℹ️ Nenhum arquivo JSON encontrado"; \
	fi
	@echo "✅ Validação completa (XML + JSON)"

generate-icons: check-deps
	@echo "🎨 Gerando ícones Nord..."
	@python3 generate_icons.py
	@echo "✅ Ícones prontos"

package: validate generate-icons
	@echo "📦 Empacotando $(OXT)..."
	@rm -f $(OXT)
	@cd $(CURDIR) && zip -r ../$(OXT) * \
		-x "*.git*" \
		-x "generate_icons.py" \
		-x "Makefile" \
		-x "README.md" \
		-x "LICENSE" \
		-x "CHANGELOG.md" \
		-x ".github*" \
		-x "__pycache__/*"
	@echo "✅ Gerado: ../$(OXT)"

clean:
	@rm -f *.oxt
	@rm -rf icons/cmd/ icons/index.json __pycache__/
	@echo " Ambiente limpo"

install: package
	@libreoffice --nologo --accept="socket,host=localhost,port=2002;urp;" &
	@unopkg add ../$(OXT)
	@echo "🚀 Instalado no perfil de usuário"