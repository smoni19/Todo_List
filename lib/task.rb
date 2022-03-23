require 'pg'
require_relative 'modules/connection_constants'
require_relative 'modules/task_constants'

class Task
  include ConnectionConstants, TaskConstants
  attr_reader :id, :details, :deadline, :completed, :todo_list_id

  def initialize(id:, details:, deadline:, completed:, todo_list_id:)
    @id = id
    @details = details
    @deadline = deadline
    @completed = completed
    @todo_list_id = todo_list_id
  end

  def self.create_new_task(result)
    Task.new(
      id: result[0]['id'],
      details: result[0]['details'],
      deadline: result[0]['deadline'],
      completed: result[0]['completed'],
      todo_list_id: result[0]['todo_list_id'])
  end

  def self.check_connection
    ENV['ENVIRONMENT'] == 'test' ? TEST_DB : LIVE_DB
  end

  def self.create(details:, deadline:, completed:, todo_list_id:)
    deadline = Time.new if deadline == ''
    create_new_task(check_connection.exec_params(NEW_TASK, [details, deadline, completed, todo_list_id]))
  end

  def self.all
    check_connection.exec_params(GET_TASKS).map do |task|
      Task.new(
        id: task['id'],
        details: task['details'],
        deadline: task['deadline'],
        completed: task['completed'],
        todo_list_id: task['todo_list_id'])
    end
  end
  
  def self.edit(id:, details:, deadline:)
    create_new_task(check_connection.exec_params(EDIT_TASK, [details, deadline, id]))
  end
  
  def self.delete(id:)
    create_new_task(check_connection.exec_params(DELETE_TASK, [id]))
  end

  def self.set_status(id:, completed:)
    completed == 'f' ? create_new_task(check_connection.exec_params(TASK_COMPLETE, [id])) : create_new_task(check_connection.exec_params(TASK_ONGOING, [id]))
  end
  
  def self.find(id:)
    return nil unless id
    create_new_task(check_connection.exec_params(GET_INFO, [id]))
  end

  def check_for_link(text)
    link_regex = /\[[^\]]*\]\{[^)]*\}/
    return text unless link_regex.match?(text)
    text_minus_link = text.gsub(link_regex, '').chars
    text_minus_link.insert(text.index(/\[\w/), create_link(text[link_regex]))
    text_minus_link.join()
  end

  def create_link(link_string)
    link_value = link_string[/\[(.*?)\]/, 1]
    link_href = link_string[/\{(.*?)\}/, 1]
    return "<a href=\"#{link_href}\">#{link_value}</a>"
  end
  
end
