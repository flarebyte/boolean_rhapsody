# Agents Index

This repository is template-driven. Prefer making documentation and maintenance changes via baldrick-reserve templates and broth workflows rather than editing files directly here.

- Source of truth for docs/templates: `../baldrick-reserve`
  - Dart templates: `baldrick-reserve/template/dart/*.hbs`
  - Scripts: `baldrick-reserve/script/*`
  - Reserve model/schema: `baldrick-reserve/reserve-schema`
- Project model and workflows: `baldrick-broth.yaml` in this repo
  - Update metadata/links/highlights in `model.*` (readme, project info)
  - Extend maintenance flows in `workflows.*`

Core docs in this repo (generated from templates):
- README: `README.md` (overview, links, usage cheat‑sheet)
- Maintenance: `MAINTENANCE.md` (broth tasks catalog)
- Technical design: `TECHNICAL_DESIGN.md`
- ADRs: `DECISIONS.md`
- Usage reference: `USAGE.md`
- Dependencies: `DEPENDENCIES.md`, `INTERNAL-DEPENDENCIES.md`

Day‑to‑day commands (local):
- Install deps: `dart pub get`
- Analyze: `dart analyze`
- Format check: `dart format --output=none --set-exit-if-changed .`
- Tests: `dart test`
- Outdated report: `dart pub outdated`

Broth alias: `broth` maps to `npx baldrick-broth@latest`.
- Unit tests: `broth test unit`
- Lint check/fix: `broth lint check` / `broth lint fix`
- Docs: `broth doc dart`
- Upgrade deps: `broth deps upgrade`
- Release checks: `broth release ready`

Editing guidance for agents:
- Prefer changing `baldrick-broth.yaml` and templates in `baldrick-reserve` to regenerate docs.
- Keep CI changes minimal and consistent with templates; propose upstream template changes when possible.
- Do not duplicate documentation across files; link to existing sources above.
