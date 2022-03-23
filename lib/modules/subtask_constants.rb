module SubtaskConstants
  NEW_SUBTASK = '
    INSERT INTO subtasks
    (details, deadline, completed, task_id)
    VALUES($1, $2, $3, $4)
    RETURNING id, details, deadline, completed, task_id;'
  GET_SUBTASKS = 'SELECT * FROM subtasks;'
  SUBTASK_COMPLETE = '
    UPDATE subtasks
    SET completed = TRUE
    WHERE id = $1
    RETURNING id, details, deadline, completed, task_id;'
  SUBTASK_ONGOING = '
    UPDATE subtasks
    SET completed = FALSE
    WHERE id = $1
    RETURNING id, details, deadline, completed, task_id;'
  EDIT_SUBTASK = '
    UPDATE subtasks
    SET details = $1, deadline = $2
    WHERE id = $3
    RETURNING id, details, deadline, completed, task_id;'
  DELETE_SUBTASK = '
    DELETE FROM subtasks
    WHERE id = $1
    RETURNING id, details, deadline, completed, task_id;'
  GET_INFO = "SELECT * FROM subtasks WHERE id = $1;"
end
