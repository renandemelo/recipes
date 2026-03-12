# AGENTS.md

This file provides guidance to agents when working with code in this repository.

## Project Overview
This is a sample application with two services:
- `recipes-db`: PostgreSQL database for storing recipes
- `recipes-webapp`: Python + FastAPI web application for CRUD operations on recipes

## Key Commands
- Build images: `./deploy.sh` (builds and deploys to k3s)
- Install k3s: `./install.sh`
- Test API: `curl http://localhost:8080/v1/recipes/`

## Architecture Notes
- The webapp service exposes port 80 internally but runs on container port 8000
- Database connection uses environment variable `DATABASE_URL` with default `postgresql://recipeuser:recipemaster@recipes-db:5432/recipesdb`
- Ingress configuration allows all hosts to access the application (removed restrictive host pattern)
- The deployment uses `imagePullPolicy: Always` in the webapp deployment

## Testing
- API tests are in `recipes-webapp/tests/test_api.py`
- Tests can be run with pytest or using the curl examples from README.md
- The application is designed to work with k3s cluster and Traefik ingress controller

## Database Schema
The PostgreSQL database contains a `recipes` table with:
- `id`: auto-incrementing primary key
- `description`: text description of the recipe
- `score`: integer rating for the recipe

## Web Interface
The application provides both:
1. REST API at `/v1/recipes/` endpoints
2. HTML CRUD interface accessible at root URL `/`