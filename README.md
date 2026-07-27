# sports-store-frontend

React (Vite) single-page app for the Sports Store storefront. Talks to the backend
services exclusively through the API gateway (`sports-store-gateway`) under `/api/*`
— it never calls a backend service directly.

## Stack

React 18, React Router, Vite.

## Local development

```bash
npm install
npm run dev
```

## Branching convention

- `feature/<short-description>` — new functionality
- `bugfix/<short-description>` — non-urgent fixes
- `hotfix/<short-description>` — urgent production fixes

All changes land on `main` via pull request with at least 1 approval (enforced by repository ruleset).
