FROM postgres:15

# Set environment variables
ENV POSTGRES_DB=recipesdb
ENV POSTGRES_USER=recipeuser
ENV POSTGRES_PASSWORD=recipemaster

# Copy initialization scripts
COPY init/ /docker-entrypoint-initdb.d/

# Expose default PostgreSQL port
EXPOSE 5432

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD pg_isready -U recipeuser -d recipesdb