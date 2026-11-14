---
name: stack-vanilla-js
description: Use for no-build vanilla ES-module JavaScript SPAs (hash routes, no bundler), alongside the backend stack skill. Covers component reuse, safe templating, routing, CSS tokens, mobile checks, and Playwright.
---

# Stack: vanilla ES-module SPA

Generic defaults. Project CLAUDE.md and `.claude/skills` (e.g. a UI skill) win on any conflict.

## Structure

- Native ES modules loaded straight by the browser; no build step, so no JSX/TypeScript/bare imports. Use relative paths with `.js` extensions.
- Hash routes (`#/section/page`); the router maps hash to a page module. Add new pages by registering the route, not by new HTML files.
- A central store may support an API mode and an in-memory mock mode; keep both working if it exists.

## Components

- Reuse shared components (table, dialog, form fields, toasts, error display) before writing new ones. Find them with a quick grep of the shared/components dir.
- Do not duplicate markup or styles that a shared component already provides.

## Safety

- Use the `html` tagged template: it auto-escapes interpolated values.
- Never assign user-controlled strings to `innerHTML` (or `insertAdjacentHTML`, `outerHTML`). Use `textContent` or the template tag.
- Do not put personal data in URLs or hashes. Server enforces permissions; UI hiding is convenience only.
- Send the CSRF header on mutating fetches if the backend requires it.

## CSS

- Use existing CSS tokens (custom properties) for colors, spacing, radius; no hard-coded hex when a token exists.
- Follow the existing breakpoints; do not invent new ones.
- Respect the project theme (e.g. light-only); do not add a dark mode unasked.

## Mobile and states

- Check at phone width: no horizontal scroll, tap targets usable, tables degrade or scroll inside a container.
- Cover loading, empty, error, and permission-denied states.

## Tests

- Playwright specs live under the project's e2e dir; follow its README for projects/roles and how to run.
- E2E may run against the dev DB: do not run destructive flows unless the spec is designed for it.
- Add or update a spec for each changed user flow; prefer role/text locators over brittle CSS selectors.
