# LibreOffice Nord Theme Collection

[![Latest Release](https://img.shields.io/github/v/release/YOUR_USERNAME/YOUR_REPOSITORY?color=blue&label=version)](https://github.com/YOUR_USERNAME/YOUR_REPOSITORY/releases/latest)
[![Build Status](https://github.com/YOUR_USERNAME/YOUR_REPOSITORY/actions/workflows/ci.yml/badge.svg)](https://github.com/YOUR_USERNAME/YOUR_REPOSITORY/actions/workflows/ci.yml)
[![License](https://img.shields.io/github/license/YOUR_USERNAME/YOUR_REPOSITORY?color=green)](LICENSE)

A free and open-source suite of modular extensions that brings the elegance, harmony, and visual comfort of the [Nord](https://www.nordtheme.com/) color palette to LibreOffice.

This repository consolidates four variants of the theme, allowing users to choose the atmosphere that best suits their workspace. Beyond restyling the toolbars, these extensions modify the document background, spreadsheet grids, syntax highlighting, and make the Nord palette natively available in the system.

## 🎨 Explore the Themes

Each extension has a unique visual identity. Select one of the themes below to view screenshots and get specific details about the palette used:

* 🌌 **[Nord Polar Night](themes/libre-nord-polar/README.md):** The classic dark theme, focused on deep, restful tones.
* ❄️ **[Nord Snow Storm](themes/libre-nord-snow/README.md):** The light, clean, and bright theme, designed for high-light environments.
* 🧊 **[Nord Frost](themes/libre-nord-frost/README.md):** An intermediate dark theme characterized by a strong presence of cold and bluish tones.
* 🌠 **[Nord Aurora](themes/libre-nord-aurora/README.md):** A vibrant dark theme that uses the colors of the Northern Lights for highlights and markings.

## ✨ Common Features

* **Full Coverage:** Styling for the user interface (UI), document editing area (Writer, Calc, etc.), and syntax highlighting (SQL, BASIC, HTML).
* **Integrated Palette:** Inclusion of the "Nord" color palette in the fill and font options (`.soc`).
* **Shared Architecture:** Clean and segmented code, making simultaneous maintenance of all variants easy.

## 🚀 How to Install

The extensions are available **completely free of charge** to the community.

1. Download the `.oxt` file for your desired theme from the [Releases](https://github.com/YOUR_USERNAME/YOUR_REPOSITORY/releases/latest) page.
2. Open LibreOffice and go to **Tools** > **Extension Manager...** (or press `Ctrl + Alt + E`).
3. Click **Add**, locate the downloaded file, and confirm the installation.
4. **Restart LibreOffice.**
5. To activate the visual theme, go to **Tools** > **Options** > **LibreOffice** > **Application Colors**. In the "Scheme" drop-down menu, select the name corresponding to the installed theme and click Apply.

## 🛠️ For Developers (How to Build)

The project uses a `Makefile` to validate the XML code and package all themes simultaneously.

**Prerequisites:** Unix-based operating system (Linux/macOS) or WSL; `make`, `zip`, and `xmllint` utilities installed.

```bash
# 1. Clone the repository
git clone [https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git](https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git)
cd YOUR_REPOSITORY

# 2. Validate the XML and package all extensions
make all
```

The final `.oxt` files will be automatically generated inside the `dist/` directory.

## 🤝 Contributing

Contributions to improve the interface are welcome. Feel free to open an *Issue* reporting visual anomalies or to submit a *Pull Request* with fixes. Please make sure to run `make validate` before submitting changes.

## ☕ Support this Project

The development and maintenance of this extension suite are done voluntarily. If the comfort provided by these themes has reduced your eye strain and you want to support the project's continuity, consider contributing.

[![Buy Me A Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=flat&logo=buy-me-a-coffee&logoColor=black)](https://www.paypal.com/donate/?business=FUYCFNEHLN8FS&no_recurring=0&currency_code=BRL)

## 📄 License

This project is licensed under the MIT License. LibreOffice is a registered trademark of The Document Foundation. The color palettes are derived from the original [Nord Theme](https://github.com/arcticicestudio/nord) project.