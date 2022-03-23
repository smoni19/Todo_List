module TaskConstants
  NEW_TASK = '
    INSERT INTO tasks
    (details, deadline, completed, todo_list_id)
    VALUES($1, $2, $3, $4)
    RETURNING id, details, deadline, completed, todo_list_id;'
  GET_TASKS = 'SELECT * FROM tasks;'
  TASK_COMPLETE = '
    UPDATE tasks
    SET completed = TRUE
    WHERE id = $1
    RETURNING id, details, deadline, completed, todo_list_id;'
  TASK_ONGOING = '
    UPDATE tasks
    SET completed = FALSE
    WHERE id = $1
    RETURNING id, details, deadline, completed, todo_list_id;'
  EDIT_TASK = '
    UPDATE tasks
    SET details = $1, deadline = $2
    WHERE id = $3
    RETURNING id, details, deadline, completed, todo_list_id;'
  DELETE_TASK = '
    DELETE FROM tasks
    WHERE id = $1
    RETURNING id, details, deadline, completed, todo_list_id;'
  GET_INFO = "SELECT * FROM tasks WHERE id = $1;"
end
