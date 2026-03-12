import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Welcome to Recipes API"}

def test_read_recipes():
    response = client.get("/recipes/")
    assert response.status_code == 200
    assert isinstance(response.json(), list)