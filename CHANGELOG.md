# Changelog
Todas as mudanças no produto serão documentadas neste arquivo.

## [1.0.5] - 2026-06-07
### Alterado
- padronizado o acento principal para nord8 (#88C0D0) em elementos de destaque (highlight, active, accent e menu highlight) nos temas dark e light
- harmonizado o destaque de menu do tema dark para o mesmo acento primário (nord8)

### Corrigido
- corrigido BASICNumber para o swatch oficial nord15 (#B48EAD), substituindo o valor fora da paleta oficial
- ajustados valores de suporte de interface para consistência de contraste entre temas (ButtonColor e CalcGrid)

## [1.0.4] - 2026-05-28
### Adicionado
- add semi-automatic changelog generation workflow

### Corrigido
- correct color values and naming in theme color files for consistency

## [1.0.0] - 2026-04-30
### Adicionado
- Suporte oficial ao LibreOffice 25.2+
- Esquemas Nord Light, Nord Dark e Nord High Contrast
- Desativação padrão de telemetria e relatórios de erro
- Renderização VCL forçada para menus e diálogos
- Script de geração automática de ícones Nord
- Pipeline CI/CD com GitHub Actions
- Makefile para validação, empacotamento e instalação