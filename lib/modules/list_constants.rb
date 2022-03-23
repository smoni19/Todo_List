module ListConstants
  NEW_LIST = '
    INSERT INTO todo_lists
    (name, category, theme, created, archived, account_id)
    VALUES($1, $2, $3, $4, $5, $6)
    RETURNING id, name, category, theme, created, archived, account_id;'
  EDIT_LIST = '
    UPDATE todo_lists
    SET name = $2, category = $3, theme = $4
    WHERE id = $1
    RETURNING id, name, category, theme, created, archived, account_id;'
  DELETE_LIST = '
    DELETE FROM todo_lists
    WHERE id = $1
    RETURNING id, name, category, theme, created, archived, account_id;'
  GET_LISTS = "SELECT * FROM todo_lists;"
  GET_INFO = "SELECT * FROM todo_lists WHERE id = $1;"
end
