module ConnectionConstants
  LIVE_DB = PG.connect(dbname: 'todo_list')
  TEST_DB = PG.connect(dbname: 'todo_list_test')
end
