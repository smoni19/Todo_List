require 'pg'
require_relative '../modules/connection_constants'
require_relative '../modules/user_constants'

class User
  include ConnectionConstants, UserConstants
  attr_reader :id, :username, :email

  def initialize(id:, username:, email:)
    @id = id
    @username = username
    @email = email
  end

  def self.create_new_user(result)
    User.new(
      id: result[0]['id'],
      username: result[0]['username'],
      email: result[0]['email'])
  end

  def self.check_connection
    ENV['ENVIRONMENT'] == 'test' ? TEST_DB : LIVE_DB
  end

  def self.create(username:, email:, password:)
    create_new_user(check_connection.exec_params(SIGN_UP, [username, email, password]))
  end

  def self.login(username:, password:)
    create_new_user(check_connection.exec_params(LOGIN, [username, password]))
  end
end
