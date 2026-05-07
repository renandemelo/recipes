import pytest
from fastapi.testclient import TestClient

def test_read_root(client):
    response = client.get("/")
    assert response.status_code == 200
    assert "Recipes CRUD Application" in response.text

def test_create_recipe(client):
    recipe_data = {"description": "Test Recipe", "score": 5}
    response = client.post("/v1/recipes/", json=recipe_data)
    assert response.status_code == 200
    data = response.json()
    assert data["description"] == "Test Recipe"
    assert data["score"] == 5
    assert "id" in data

def test_read_recipes(client):
    # Create a recipe first
    client.post("/v1/recipes/", json={"description": "Recipe 1", "score": 4})
    client.post("/v1/recipes/", json={"description": "Recipe 2", "score": 3})
    
    response = client.get("/v1/recipes/")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    assert len(data) >= 2

def test_read_recipe_by_id(client):
    # Create a recipe
    response = client.post("/v1/recipes/", json={"description": "Single Recipe", "score": 5})
    recipe_id = response.json()["id"]
    
    # Read it back
    response = client.get(f"/v1/recipes/{recipe_id}")
    assert response.status_code == 200
    assert response.json()["description"] == "Single Recipe"

def test_read_recipe_not_found(client):
    response = client.get("/v1/recipes/999")
    assert response.status_code == 404

def test_update_recipe(client):
    # Create a recipe
    response = client.post("/v1/recipes/", json={"description": "Old Description", "score": 1})
    recipe_id = response.json()["id"]
    
    # Update it
    update_data = {"description": "New Description", "score": 10}
    response = client.put(f"/v1/recipes/{recipe_id}", json=update_data)
    assert response.status_code == 200
    assert response.json()["description"] == "New Description"
    assert response.json()["score"] == 10

def test_update_recipe_not_found(client):
    response = client.put("/v1/recipes/999", json={"description": "No", "score": 0})
    assert response.status_code == 404

def test_delete_recipe(client):
    # Create a recipe
    response = client.post("/v1/recipes/", json={"description": "To be deleted", "score": 1})
    recipe_id = response.json()["id"]
    
    # Delete it
    response = client.delete(f"/v1/recipes/{recipe_id}")
    assert response.status_code == 200
    assert response.json()["message"] == "Recipe deleted successfully"
    
    # Verify it's gone
    response = client.get(f"/v1/recipes/{recipe_id}")
    assert response.status_code == 404

def test_delete_recipe_not_found(client):
    response = client.delete("/v1/recipes/999")
    assert response.status_code == 404
