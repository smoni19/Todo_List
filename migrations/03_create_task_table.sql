CREATE TABLE tasks(id SERIAL PRIMARY KEY, details VARCHAR(200), to_complete_by TIMESTAMP WITH TIME ZONE, completed BOOLEAN DEFAULT FALSE, todo_list_id INTEGER REFERENCES todo_lists (id));