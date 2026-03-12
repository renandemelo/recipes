# Project Coding Rules (Non-Obvious Only)

- The webapp service internally runs on port 8000 but is exposed externally on port 80
- Database connection uses environment variable `DATABASE_URL` with default `postgresql://recipeuser:recipemaster@recipes-db:5432/recipesdb`
- API endpoints are prefixed with `/v1/` (e.g., `/v1/recipes/`)
- The application uses FastAPI with Pydantic models for request/response validation
- HTML templates are in `recipes-webapp/app/templates/` directory
- Static files are served from `recipes-webapp/app/static/` directory
- Tests are located in `recipes-webapp/tests/` directory
- The ingress configuration allows all hosts to access the application (removed restrictive host pattern)