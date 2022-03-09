CREATE TABLE tasks(id SERIAL PRIMARY KEY, details VARCHAR(200), deadline TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, completed BOOLEAN NOT NULL DEFAULT FALSE, todo_list_id INTEGER REFERENCES todo_lists (id));