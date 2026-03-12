# Recipes Application

This is a sample application with two services:
- `recipes-db`: PostgreSQL database for storing recipes
- `recipes-webapp`: Python + FastAPI web application for CRUD operations on recipes

## Project Structure

```
.
├── README.md
├── install.sh              # Script to install k3s
├── deploy.sh               # Script to build images and deploy to k3s
├── recipes-db/
│   ├── Dockerfile          # Dockerfile for PostgreSQL database
│   └── init/
│       └── 01-create-recipes-table.sql  # Database initialization script
└── recipes-webapp/
    ├── Dockerfile          # Dockerfile for FastAPI web application
    ├── requirements.txt    # Python dependencies
    └── app/
        └── main.py         # Main FastAPI application
└── k8s/
    ├── recipes-db-deployment.yaml   # Kubernetes deployment for database
    └── recipes-webapp-deployment.yaml  # Kubernetes deployment for web app
```

## Features

- **Database Service**: PostgreSQL with a `recipes` table containing:
  - `id`: auto-incrementing primary key
  - `description`: text description of the recipe
  - `score`: integer rating for the recipe

- **Web Application**: FastAPI REST API with CRUD operations:
  - GET `/v1/recipes/` - List all recipes
  - GET `/v1/recipes/{recipe_id}` - Get a specific recipe
  - POST `/v1/recipes/` - Create a new recipe
  - PUT `/v1/recipes/{recipe_id}` - Update an existing recipe
  - DELETE `/v1/recipes/{recipe_id}` - Delete a recipe

- **Web Interface**: HTML CRUD application accessible at the root URL `/`

## Setup Instructions

### Prerequisites
- Docker installed
- kubectl installed (for interacting with Kubernetes)

### Installation
1. Install k3s:
   ```bash
   ./install.sh
   ```
   
   Note: This installation disables the default Traefik ingress controller and ensures ports 80 and 443 are free before installing k3s.

2. Deploy the application:
   ```bash
   ./deploy.sh
   ```

### Troubleshooting

If you encounter issues with image deployment, such as `ErrImageNeverPull` errors, make sure that:
1. You have run `./install.sh` to set up k3s properly
2. The Docker images are built locally before deployment
3. The Kubernetes manifests use `imagePullPolicy: IfNotPresent` instead of `Never`

The deployment script automatically handles building the Docker images and deploying them to the k3s cluster.

### Usage
After deployment, you can access the API at `http://localhost/` (the webapp service is exposed on port 80).
The HTML CRUD interface is available at the root URL `/`.
The REST API is available under the `/v1/` prefix.

## Testing

You can test the API using curl or any HTTP client:

```bash
# Get all recipes
curl http://localhost:8080/v1/recipes/

# Create a new recipe
curl -X POST "http://localhost:8080/v1/recipes/" \
  -H "Content-Type: application/json" \
  -d '{"description": "New Recipe", "score": 5}'

# Get a specific recipe
curl http://localhost:8080/v1/recipes/1

# Update a recipe
curl -X PUT "http://localhost:8080/v1/recipes/1" \
  -H "Content-Type: application/json" \
  -d '{"description": "Updated Recipe", "score": 4}'

# Delete a recipe
curl -X DELETE "http://localhost:8080/v1/recipes/1"
```

## Docker Images

- `recipes-db`: PostgreSQL database with initialized recipes table
- `recipes-webapp`: Python FastAPI application connected to the database

## Kubernetes Deployment

The deployment uses:
- Two Kubernetes Deployments (one for each service)
- Two Kubernetes Services (for internal communication)
- Proper health checks and readiness probes