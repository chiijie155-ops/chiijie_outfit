# Deployment

## GitHub Pages static hosting

The `services/web/public` folder now contains a static frontend that can be deployed to GitHub Pages.

A GitHub Actions workflow is included at `.github/workflows/gh-pages.yml`. On every push to `main`, it will publish the static files to the `gh-pages` branch.

### Notes

- The static frontend has a fallback product list when the backend API is not available.
- Full dynamic behavior (checkout, live product API) requires hosting the backend services too.

## Publishing the frontend

1. Push changes to `main`.
2. Ensure GitHub Pages is configured to serve from the `gh-pages` branch.
3. Open your pages site at:
   - `https://<username>.github.io/<repository>/`

## Deploying the backend

The repository already contains Dockerfiles for the services in `services/web` and `services/catalog`.

You can deploy the backend on any Docker host or container platform by running:

```bash
docker compose up --build
```

For production, use a container registry and host that supports Docker containers.

## Next step

If you want, I can also add a GitHub Actions workflow to build and push Docker images for the backend services to GitHub Container Registry (GHCR).