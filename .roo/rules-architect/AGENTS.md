# Project Architecture Rules (Non-Obvious Only)

- The webapp service exposes port 80 internally but runs on container port 8000
- Database connection uses environment variable `DATABASE_URL` with default `postgresql://recipeuser:recipemaster@recipes-db:5432/recipesdb`
- Ingress configuration allows all hosts to access the application (removed restrictive host pattern)
- The deployment uses `imagePullPolicy: Always` in the webapp deployment
- The application is designed to work with k3s cluster and Traefik ingress controller
- The database schema contains a `recipes` table with `id`, `description`, and `score` columns