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

validate-manifest:
	@echo "🔍 Validando manifest.xml..."
	@xmllint --noout META-INF/manifest.xml || { echo "❌ Erro no manifest.xml"; exit 1; }
	@entries=$$(grep -c '<manifest:file-entry' META-INF/manifest.xml); \
	if [ "$$entries" -lt 8 ]; then \
		echo "⚠️  Aviso: apenas $$entries entradas no manifest (esperado >= 8)"; \
	fi
	@echo "✅ manifest.xml válido"

validate-xcu:
	@echo "🔍 Validando estrutura de arquivos .xcu..."
	@if [ -z "$$(find . -name '*.xcu' -not -path './.github/*' -print -quit)" ]; then \
		echo "️ Nenhum arquivo .xcu encontrado"; \
	else \
		for f in $$(find . -name '*.xcu' -not -path './.github/*'); do \
			xmllint --noout "$$f" || { echo "❌ Erro de sintaxe ou múltiplas raízes em $$f"; exit 1; }; \
		done; \
		echo "✅ Todos os .xcu estão válidos"; \
	fi

validate-json:
	@echo " Validando JSON..."
	@if [ -n "$(JSON_FILES)" ]; then \
		python3 -m json.tool $(JSON_FILES) > /dev/null || { echo "❌ Erro de sintaxe em JSON"; exit 1; }; \
	else \
		echo "ℹ️ Nenhum arquivo JSON encontrado"; \
	fi

validate: check-deps validate-manifest validate-xcu validate-json
	@echo "✅ Validação completa (XML + JSON)"

generate-icons: check-deps
	@echo "🎨 Gerando ícones Nord..."
	@if [ -f "generate_icons.py" ]; then \
		python3 generate_icons.py || { echo "⚠️  Falha ao gerar ícones, continuando sem eles..."; }; \
	else \
		echo "⚠️  generate_icons.py não encontrado, pulando geração de ícones..."; \
	fi
	@echo "✅ Etapa de ícones concluída"

package: validate generate-icons
	@echo "📦 Empacotando $(OXT)..."
	@rm -f $(OXT)
	
	# Cria arquivo mimetype NA RAIZ do projeto (temporário)
	# @printf "application/vnd.sun.star.package-bundle" > mimetype
	
	# Adiciona mimetype PRIMEIRO e SEM compressão (requisito ODF)
	# @zip -0 -X $(OXT) mimetype
	
	# Adiciona description.xml SEM compressão (segundo arquivo obrigatório)
	# @zip -0 -X $(OXT) description.xml
	
	# Adiciona diretórios restantes com compressão normal
	@zip -r -X $(OXT) \
		description.xml \
		*.xcu \
		assets/ \
		META-INF/ \
		paletas/ \
		pkg-description/ \
		registration/ \
		--exclude "*.git*" \
		--exclude "generate_icons.py" \
		--exclude "Makefile" \
		--exclude "README.md" \
		--exclude "LICENSE" \
		--exclude "CHANGELOG.md" \
		--exclude ".github/*" \
		--exclude "__pycache__/*" \
		--exclude "*.oxt" 
	
	
	
	# Remove arquivo temporário
	@rm -f mimetype
	
	@echo "✅ Gerado: ../$(OXT)"
	
	# Validação pós-build
	#@echo "🔍 Validando estrutura do pacote..."
	#@MIME=$$(unzip -p $(OXT) mimetype 2>/dev/null); \
	#if [ "$$MIME" = "application/vnd.sun.star.package-bundle" ]; then \
	#	echo "✅ mimetype correto: $$MIME"; \
	#else \
	#	echo "❌ mimetype incorreto ou ausente: '$$MIME'"; \
	#	unzip -l $(OXT) | grep -i mime || echo "⚠️  Nenhum arquivo 'mimetype' encontrado no ZIP"; \
	#	exit 1; \
	#fi

clean:
	@rm -f *.oxt
	@rm -rf icons/cmd/ icons/index.json __pycache__/
	@echo " Ambiente limpo"

install: package
	@libreoffice --nologo --accept="socket,host=localhost,port=2002;urp;" &
	@unopkg add ../$(OXT)
	@echo "🚀 Instalado no perfil de usuário"