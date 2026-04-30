# 🎨 Libre Nord
> Um tema completo e imersivo baseado na paleta **Nord** para LibreOffice 25.2+

## ✨ Recursos
- 🌓 **Nord Light, Dark & High Contrast** (WCAG AA/AAA)
- 🖥️ Integração nativa com `Ferramentas > Opções > Aparência`
- 🔒 **Privacidade**: Telemetria, relatórios de erro e atualizações automáticas desativados por padrão
- 🎯 Menus e diálogos renderizados via VCL para consistência visual
- 📦 Pipeline CI/CD com validação XML e empacotamento automático

## 📥 Instalação
1. Baixe a versão mais recente em [Releases](https://github.com/gomesluiz/libre-nord/releases)
2. Abra o LibreOffice → `Ferramentas > Gerenciador de Extensões > Adicionar...`
3. Selecione `libre-nord-1.0.0.oxt` e reinicie o aplicativo
4. `Ferramentas > Opções > Aparência` → Escolha `Nord Light`, `Nord Dark` ou `Nord High Contrast`

## 🛠 Desenvolvimento
### Pré-requisitos
- LibreOffice 25.2+
- Python 3.8+
- `make`, `zip`, `xmllint`

### Build Local
```bash
git clone https://github.com/SEU_USUARIO/libre-nord.git
cd libre-nord
python3 generate_icons.py   # Gera ícones a partir do Colibre
make package                # Valida e empacota o .oxt