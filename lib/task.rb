require 'pg'

class Task
  attr_reader :id, :details, :deadline, :completed, :todo_list_id

  @live_db = PG.connect(dbname: 'todo_list')
  @test_db = PG.connect(dbname: 'todo_list_test')
  @new_task = '
    INSERT INTO tasks
    (details, deadline, completed, todo_list_id)
    VALUES($1, $2, $3, $4)
    RETURNING id, details, deadline, completed, todo_list_id;'
  @get_tasks = 'SELECT * FROM tasks;'
  @task_complete = '
    UPDATE tasks
    SET completed = TRUE
    WHERE id = $1
    RETURNING id, details, deadline, completed, todo_list_id;'
  @task_ongoing = '
    UPDATE tasks
    SET completed = FALSE
    WHERE id = $1
    RETURNING id, details, deadline, completed, todo_list_id;'

  def initialize(id:, details:, deadline:, completed:, todo_list_id:)
    @id = id
    @details = details
    @deadline = deadline
    @completed = completed
    @todo_list_id = todo_list_id
  end

  def self.create(details:, deadline:, completed:, todo_list_id:)
    if deadline == ''
      deadline = Time.new
    end
    ENV['ENVIRONMENT'] == 'test' ? connection = @test_db : connection = @live_db
    result = connection.exec_params(@new_task, [details, deadline, completed, todo_list_id])
    Task.new(
      id: result[0]['id'],
      details: result[0]['details'],
      deadline: result[0]['deadline'],
      completed: result[0]['completed'],
      todo_list_id: result[0]['todo_list_id'])
  end

  def self.all
    ENV['ENVIRONMENT'] == 'test' ? connection = @test_db : connection = @live_db
    result = connection.exec_params(@get_tasks)
    result.map do |task|
      Task.new(
        id: task['id'],
        details: task['details'],
        deadline: task['deadline'],
        completed: task['completed'],
        todo_list_id: task['todo_list_id'])
    end
  end

  def self.set_status(id:, completed:)
    ENV['ENVIRONMENT'] == 'test' ? connection = @test_db : connection = @live_db
    completed == 'f' ? result = connection.exec_params(@task_complete, [id]) : result = connection.exec_params(@task_ongoing, [id])
    Task.new(
      id: result[0]['id'],
      details: result[0]['details'],
      deadline: result[0]['deadline'],
      completed: result[0]['completed'],
      todo_list_id: result[0]['todo_list_id'])
  end
  
end
