require 'pg'

def reset_test_database
  connection = PG.connect(dbname: 'todo_list_test')
  connection.exec('TRUNCATE todo_lists CASCADE')
  connection.exec('TRUNCATE tasks CASCADE')
  connection.exec('TRUNCATE users CASCADE')
end
