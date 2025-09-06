# Agents Index

This repository is template-driven. Prefer making documentation and
maintenance changes via baldrick-reserve templates and broth workflows rather
than editing files directly here.

-   Source of truth for docs/templates: `../baldrick-reserve`
    -   Dart templates: `baldrick-reserve/template/dart/*.hbs`
    -   Scripts: `baldrick-reserve/script/*`
    -   Reserve model/schema: `baldrick-reserve/reserve-schema`
-   Project model and workflows: `baldrick-broth.yaml` in this repo
    -   Update metadata/links/highlights in `model.*` (readme, project info)
    -   Extend maintenance flows in `workflows.*`

Core docs in this repo (generated from templates):

-   README: `README.md` (overview, links, usage cheat‑sheet)
-   Maintenance: `MAINTENANCE.md` (broth tasks catalog)
-   Technical design: `TECHNICAL_DESIGN.md`
-   ADRs: `DECISIONS.md`
-   Usage reference: `USAGE.md`
-   Dependencies: `DEPENDENCIES.md`, `INTERNAL-DEPENDENCIES.md`

Day‑to‑day commands (local):

-   Install deps: `dart pub get`
-   Analyze: `dart analyze`
-   Format check: `dart format --output=none --set-exit-if-changed .`
-   Tests: `dart test`
-   Outdated report: `dart pub outdated`

Broth alias: `broth` maps to `npx baldrick-broth@latest`.

-   Unit tests: `broth test unit`
-   Lint check/fix: `broth lint check` / `broth lint fix`
-   Docs: `broth doc dart`
-   Upgrade deps: `broth deps upgrade`
-   Release checks: `broth release ready`

Editing guidance for agents:

-   Prefer changing `baldrick-broth.yaml` and templates in
    `baldrick-reserve` to regenerate docs.
-   Keep CI changes minimal and consistent with templates; propose upstream
    template changes when possible.
-   Do not duplicate documentation across files; link to existing sources
    above.

## Dependency Update Process

-   Preferred path: encode/update flows in `baldrick-broth.yaml` (e.g.,
    `workflows.deps`), then run via `broth`. For ad‑hoc local updates,
    follow the one‑by‑one steps below.

-   Discover candidates

    -   Run `dart pub outdated --no-prereleases` to list upgradable and latest
        versions.
    -   Run `broth deps upgrade` for a preview of the template flow (batch);
        cancel if you intend to upgrade individually.

-   Update one dependency at a time

    -   For runtime deps: `dart pub add <package>` (or `dart pub add <package>:^<target>` to pin).
    -   For dev deps: `dart pub add --dev <package>`.
    -   This updates `pubspec.yaml` constraint and refreshes `pubspec.lock`.

-   Validate after each change

    -   Run unit tests: `dart test` (or `broth test unit`).
    -   Optional: `flutter test` and coverage via Broth flow: `npx
        baldrick-broth@latest test unit` (runs `flutter test --coverage`).
    -   If tests fail or regress, rollback the change:
        -   Revert `pubspec.yaml`/`pubspec.lock` (e.g., `git checkout --
            pubspec.yaml pubspec.lock`), or re‑apply the prior constraint via `dart
            pub add`.

-   SDK‑gated updates

    -   Some packages (e.g., `lints` >= 6.0.0) require a newer Dart SDK than
        specified in `environment.sdk`.
    -   If hitting a solver error, consider an SDK bump flow:
        -   Update `environment.sdk` in `pubspec.yaml` to the required range.
        -   Ensure toolchains locally/CI match (e.g., asdf, CI images).
        -   Run `dart pub get`, `dart analyze`, and full tests, then proceed with
            the update.

-   Commit strategy

    -   One commit per dependency with message: `deps(<package>): bump to <version>` and brief test result note.
    -   For rollbacks, reference the failing test or error in the message.

-   Templates first
    -   If the process needs to be repeatable across repos, prefer adding or
        adjusting a Broth workflow in `baldrick-broth.yaml` and/or templates in
        `../baldrick-reserve` (`script/*`, `template/dart/*`).

## Markdown Update Process

-   Prefer templates

    -   When docs are template-driven, edit in `../baldrick-reserve` and
        regenerate via `broth doc dart` rather than changing Markdown directly
        here.

-   If you change any `.md` locally

    -   Format: run `broth md fix` (alias for `npx baldrick-broth@latest md
        fix`).
    -   Verify links/anchors: ensure intra-repo links and headings still
        resolve.
    -   Keep content DRY: link to existing docs (README, USAGE, DECISIONS)
        instead of duplicating text.
    -   Keep sections concise and scannable; avoid heavy formatting unsupported
        by the CLI renderer.

-   When documenting processes

    -   Repo-wide conventions live in `AGENTS.md`.
    -   Architectural decisions go to `DECISIONS.md`.
    -   One-off change logs or investigation notes can go to `code-report.md`
        and be pruned later.

-   Commit strategy
    -   Group related Markdown edits in one commit: `docs: tidy markdown and
        update <sections>`.
    -   Include `broth md fix` in your PR checklist or commit footer for
        traceability.
