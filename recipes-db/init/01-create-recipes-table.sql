-- Create recipes table
CREATE TABLE IF NOT EXISTS recipes (
    id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    score INTEGER DEFAULT 0
);

-- Insert sample data
INSERT INTO recipes (description, score) VALUES 
    ('Spaghetti Carbonara', 5),
    ('Chicken Tikka Masala', 4),
    ('Vegetable Stir Fry', 3);