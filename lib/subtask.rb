require 'pg'

class Subtask
  attr_reader :id, :details, :deadline, :completed, :task_id

  @live_db = PG.connect(dbname: 'todo_list')
  @test_db = PG.connect(dbname: 'todo_list_test')
  @new_subtask = '
    INSERT INTO subtasks
    (details, deadline, completed, task_id)
    VALUES($1, $2, $3, $4)
    RETURNING id, details, deadline, completed, task_id;'
  @get_subtasks = 'SELECT * FROM subtasks;'
  @subtask_complete = '
    UPDATE subtasks
    SET completed = TRUE
    WHERE id = $1
    RETURNING id, details, deadline, completed, task_id;'
  @subtask_ongoing = '
    UPDATE subtasks
    SET completed = FALSE
    WHERE id = $1
    RETURNING id, details, deadline, completed, task_id;'
  @edit_subtask = '
    UPDATE subtasks
    SET details = $1, deadline = $2
    WHERE id = $3
    RETURNING id, details, deadline, completed, task_id;'
  @delete_subtask = '
    DELETE FROM subtasks
    WHERE id = $1
    RETURNING id, details, deadline, completed, task_id;'
  @get_info = "SELECT * FROM subtasks WHERE id = $1;"

  def initialize(id:, details:, deadline:, completed:, task_id:)
    @id = id
    @details = details
    @deadline = deadline
    @completed = completed
    @task_id = task_id
  end

  def self.create(details:, deadline:, completed:, task_id:)
    if deadline == ''
      deadline = Time.new
    end
    ENV['ENVIRONMENT'] == 'test' ? connection = @test_db : connection = @live_db
    result = connection.exec_params(@new_subtask, [details, deadline, completed, task_id])
    Subtask.new(
      id: result[0]['id'],
      details: result[0]['details'],
      deadline: result[0]['deadline'],
      completed: result[0]['completed'],
      task_id: result[0]['task_id'])
  end

  def self.all
    ENV['ENVIRONMENT'] == 'test' ? connection = @test_db : connection = @live_db
    result = connection.exec_params(@get_subtasks)
    result.map do |subtask|
      Subtask.new(
        id: subtask['id'],
        details: subtask['details'],
        deadline: subtask['deadline'],
        completed: subtask['completed'],
        task_id: subtask['task_id'])
    end
  end
  
  def self.edit(id:, details:, deadline:)
    ENV["ENVIRONMENT"] == "test" ? connection = @test_db : connection = @live_db
    result = connection.exec_params(@edit_subtask, [details, deadline, id])
    Subtask.new(
      id: result[0]['id'],
      details: result[0]['details'],
      deadline: result[0]['deadline'],
      completed: result[0]['completed'],
      task_id: result[0]['task_id'])
  end
  
  def self.delete(id:)
    ENV["ENVIRONMENT"] == "test" ? connection = @test_db : connection = @live_db
    result = connection.exec_params(@delete_subtask, [id])
    Subtask.new(
      id: result[0]['id'],
      details: result[0]['details'],
      deadline: result[0]['deadline'],
      completed: result[0]['completed'],
      task_id: result[0]['task_id'])
  end

  def self.set_status(id:, completed:)
    ENV['ENVIRONMENT'] == 'test' ? connection = @test_db : connection = @live_db
    completed == 'f' ? result = connection.exec_params(@subtask_complete, [id]) : result = connection.exec_params(@subtask_ongoing, [id])
    Subtask.new(
      id: result[0]['id'],
      details: result[0]['details'],
      deadline: result[0]['deadline'],
      completed: result[0]['completed'],
      task_id: result[0]['task_id'])
  end
  
  def self.find(id:)
    return nil unless id
    ENV["ENVIRONMENT"] == "test" ? connection = @test_db : connection = @live_db
    result = connection.exec_params(@get_info, [id])
    Subtask.new(
      id: result[0]['id'],
      details: result[0]['details'],
      deadline: result[0]['deadline'],
      completed: result[0]['completed'],
      task_id: result[0]['task_id'])
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
