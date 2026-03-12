import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    # The root now returns HTML, not JSON
    assert "Recipes CRUD Application" in response.text

def test_read_recipes():
    response = client.get("/v1/recipes/")
    assert response.status_code == 200
    assert isinstance(response.json(), list)