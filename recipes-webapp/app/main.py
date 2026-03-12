from fastapi import FastAPI, HTTPException, Depends
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from pydantic import BaseModel
import os

# Database setup
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://recipeuser:recipemaster@recipes-db:5432/recipesdb")
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# Pydantic models
class RecipeBase(BaseModel):
    description: str
    score: int

class RecipeCreate(RecipeBase):
    pass

class Recipe(RecipeBase):
    id: int
    
    class Config:
        from_attributes = True

# Database model
class RecipeModel(Base):
    __tablename__ = "recipes"
    
    id = Column(Integer, primary_key=True, index=True)
    description = Column(String, index=True)
    score = Column(Integer)

# FastAPI app
app = FastAPI(title="Recipes API", version="1.0.0")

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Routes
@app.get("/")
async def root():
    return {"message": "Welcome to Recipes API"}

@app.get("/recipes/")
async def read_recipes(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    recipes = db.query(RecipeModel).offset(skip).limit(limit).all()
    return recipes

@app.get("/recipes/{recipe_id}")
async def read_recipe(recipe_id: int, db: Session = Depends(get_db)):
    recipe = db.query(RecipeModel).filter(RecipeModel.id == recipe_id).first()
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")
    return recipe

@app.post("/recipes/")
async def create_recipe(recipe: RecipeCreate, db: Session = Depends(get_db)):
    db_recipe = RecipeModel(**recipe.model_dump())
    db.add(db_recipe)
    db.commit()
    db.refresh(db_recipe)
    return db_recipe

@app.put("/recipes/{recipe_id}")
async def update_recipe(recipe_id: int, recipe: RecipeCreate, db: Session = Depends(get_db)):
    db_recipe = db.query(RecipeModel).filter(RecipeModel.id == recipe_id).first()
    if not db_recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")
    
    for key, value in recipe.model_dump().items():
        setattr(db_recipe, key, value)
    
    db.commit()
    db.refresh(db_recipe)
    return db_recipe

@app.delete("/recipes/{recipe_id}")
async def delete_recipe(recipe_id: int, db: Session = Depends(get_db)):
    db_recipe = db.query(RecipeModel).filter(RecipeModel.id == recipe_id).first()
    if not db_recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")
    
    db.delete(db_recipe)
    db.commit()
    return {"message": "Recipe deleted successfully"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)