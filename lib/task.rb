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
  @edit_task = '
    UPDATE tasks
    SET details = $1, deadline = $2
    WHERE id = $3
    RETURNING id, details, deadline, completed, todo_list_id;'
  @delete_task = '
    DELETE FROM tasks
    WHERE id = $1
    RETURNING id, details, deadline, completed, todo_list_id;'
  @get_info = "SELECT * FROM tasks WHERE id = $1;"

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
  
  def self.edit(id:, details:, deadline:)
    ENV["ENVIRONMENT"] == "test" ? connection = @test_db : connection = @live_db
    result = connection.exec_params(@edit_task, [details, deadline, id])
    Task.new(
      id: result[0]['id'],
      details: result[0]['details'],
      deadline: result[0]['deadline'],
      completed: result[0]['completed'],
      todo_list_id: result[0]['todo_list_id'])
  end
  
  def self.delete(id:)
    ENV["ENVIRONMENT"] == "test" ? connection = @test_db : connection = @live_db
    result = connection.exec_params(@delete_task, [id])
    Task.new(
      id: result[0]['id'],
      details: result[0]['details'],
      deadline: result[0]['deadline'],
      completed: result[0]['completed'],
      todo_list_id: result[0]['todo_list_id'])
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
  
  def self.find(id:)
    return nil unless id
    ENV["ENVIRONMENT"] == "test" ? connection = @test_db : connection = @live_db
    result = connection.exec_params(@get_info, [id])
    Task.new(
      id: result[0]['id'],
      details: result[0]['details'],
      deadline: result[0]['deadline'],
      completed: result[0]['completed'],
      todo_list_id: result[0]['todo_list_id'])
  end

  def check_for_link(text)
    link_regex = /\[[^\]]*\]\{[^)]*\}/
    return text unless link_regex.match?(text)
    text_minus_link = text.gsub(link_regex, '').chars
    link_index = text.index(/\[\w/)
    text_minus_link.insert(link_index, create_link(text[link_regex]))
    text_minus_link.join()
  end

  def create_link(link_string)
    link_value = link_string[/\[(.*?)\]/, 1]
    link_href = link_string[/\{(.*?)\}/, 1]
    return "<a href=\"#{link_href}\">#{link_value}</a>"
  end
  
end
