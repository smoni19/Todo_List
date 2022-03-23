require 'pg'
require_relative 'modules/connection_constants'
require_relative 'modules/list_constants'

class List
  include ConnectionConstants, ListConstants
  attr_reader :id, :name, :category, :theme, :created, :archived, :account_id

  def initialize(id:, name:, category:, theme:, created:, archived:, account_id:)
    @id = id
    @name = name
    @category = category
    @theme = theme
    @created = created
    @archived = archived
    @account_id = account_id
  end

  def self.create_new_list(result)
    List.new(
      id: result[0]['id'],
      name: result[0]['name'],
      category: result[0]['category'],
      theme: result[0]['theme'],
      created: result[0]['created'],
      archived: result[0]['archived'],
      account_id: result[0]['account_id'])
  end

  def self.check_connection
    ENV['ENVIRONMENT'] == 'test' ? TEST_DB : LIVE_DB
  end

  def self.create(name:, category:, theme:, created:, archived:, account_id:)
    create_new_list(check_connection.exec_params(NEW_LIST, [name, category, theme, created, archived, account_id]))
  end
  
  def self.all
    check_connection.exec_params(GET_LISTS).map do |list|
      List.new(
        id: list["id"],
        name: list["name"],
        category: list["category"],
        theme: list["theme"],
        created: list["created"],
        archived: list["archived"],
        account_id: list["account_id"])
    end
  end

  def self.find(id:)
    return nil unless id
    create_new_list(check_connection.exec_params(GET_INFO, [id]))
  end

  def self.edit(id:, name:, category:, theme:)
    create_new_list(check_connection.exec_params(EDIT_LIST, [id, name, category, theme]))
  end

  def self.delete(id:)
    create_new_list(check_connection.exec_params(DELETE_LIST, [id]))
  end

end
