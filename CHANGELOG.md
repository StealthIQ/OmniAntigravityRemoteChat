# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.6] - 2026-02-22

### Added

- 🔄 GitHub Actions CI workflow (Node 18/20/22 matrix)
- 📖 Updated all documentation to reflect current project state

### Changed

- 🔢 Version scheme aligned to 0.3.x (was incorrectly set to 2.0.0)

## [0.3.5] - 2026-02-22

### Added

- 🤖 `AGENTS.md` — AI coding assistant instructions
- 📋 `CHANGELOG.md` — version history (Keep a Changelog)
- 🤝 `CODE_OF_CONDUCT.md` — Contributor Covenant v2.1
- 📝 `.github/ISSUE_TEMPLATE/bug_report.md` and `feature_request.md`
- 📝 `.github/PULL_REQUEST_TEMPLATE.md`
- Moved `SECURITY.md` and `CONTRIBUTING.md` to project root

## [0.3.4] - 2026-02-22

### Changed

- 📁 Project reorganized into `src/`, `scripts/`, `docs/` structure
- `server.js` → `src/server.js` with `PROJECT_ROOT` constant
- Shell scripts → `scripts/start.sh`, `scripts/start_web.sh`
- Documentation → `docs/`
- Updated all import paths and npm scripts

## [0.3.3] - 2026-02-22

### Removed

- 🗑️ `launcher.py` removed — project is now 100% Node.js (zero Python)
- Cleaned up `.venv/` virtual environment

## [0.3.2] - 2026-02-22

### Added

- 🧪 Validation test suite (`test.js`) with 25 checks
- 📖 Step-by-step README with setup guide, port reference, troubleshooting

### Changed

- 🔧 CDP debug ports: `9000` → `7800` (avoids PHP-FPM/SonarQube conflicts)
- 🔧 Web server default port: `3000` → `4747` (avoids Express/React conflicts)
- Updated `~/.bashrc` alias `agd` to use port 7800

## [0.3.1] - 2026-02-22

### Added

- ✨ Rebranded to **OmniAntigravity Remote Chat**
- 🎨 Premium mobile UI: gradient brand palette, pulse animations, glassmorphism, spring-animated modals
- 🪟 Multi-window CDP support: `discoverAllCDP()`, `/cdp-targets`, `/select-target` endpoints
- 🚀 Node.js launcher (`launcher.js`) with QR code and ngrok support
- 🔁 Auto-reconnect: exponential backoff, WebSocket heartbeat, CDP status broadcasting, mobile toast notifications

### Fixed

- 🐛 Critical CDP port mismatch: was scanning `5000-5003` instead of `9000-9003`
- 🐛 Auth cookie renamed from `ag_auth_token` to `omni_ag_auth`

## [0.3.0] - 2026-02-22

### Changed

- 🚀 Forked as **OmniAntigravityRemoteChat** from `antigravity_phone_chat`
- Git remote switched to `diegosouzapw/OmniAntigravityRemoteChat`
- Updated `.gitignore` with `.venv/`
- Shell scripts updated to prioritize local Python venv (PEP 668 fix)

---

## Pre-Fork History (antigravity_phone_chat)

### [0.2.17] - 2026-02-21

- Documentation sync for v0.2.17

### [0.2.14 → 0.2.16]

- Updated available AI models
- Glassmorphism UI for quick actions and settings bar
- Dark mode styling and model detection fixes

### [0.2.10 → 0.2.13]

- Enhanced DOM cleanup in snapshot capture
- Chat history features and security improvements

### [0.2.5 → 0.2.9]

- Chat history management with conversation controls
- Full-screen history layer, model selector improvements
- Multiple chat container ID support

### [0.2.0 → 0.2.4]

- Global remote access with web tunneling
- Unified Python launcher, context menu icons
- Auto `.env` creation from template

### [0.1.0 → 0.1.9]

- SSL certificate generation and HTTPS support
- Scroll sync, mobile copy buttons, user scroll lock
- Client-side authentication, web access with login page

### [0.0.1 → 0.0.12]

- Initial release with CDP-based chat mirroring
- Premium dark theme UI
- Context menu installation scripts for Windows/Linux
