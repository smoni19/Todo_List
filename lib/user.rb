require 'pg'

class User
  attr_reader :id, :username, :email

  @live_db = PG.connect(dbname: 'todo_list')
  @test_db = PG.connect(dbname: 'todo_list_test')
  @sign_up = '
    INSERT INTO users
    (username, email, password)
    VALUES($1, $2, $3)
    RETURNING id, username, email;'
  @login = 'SELECT * FROM users WHERE username = $1 AND password = $2;'

  def initialize(id:, username:, email:)
    @id = id
    @username = username
    @email = email
  end

  def self.create(username:, email:, password:)
    ENV['ENVIRONMENT'] == 'test' ? connection = @test_db : connection = @live_db
    result = connection.exec_params(@sign_up, [username, email, password])
    User.new(
      id: result[0]['id'],
      username: result[0]['username'],
      email: result[0]['email'])
  end

  def self.login(username:, password:)
    ENV["ENVIRONMENT"] == "test" ? connection = @test_db : connection = @live_db
    result = connection.exec_params(@login, [username, password])
    return unless result.any?
    User.new(
      id: result[0]["id"],
      username: result[0]["username"],
      email: result[0]["email"])
  end
end
