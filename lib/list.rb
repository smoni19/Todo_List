require 'pg'

class List
  attr_reader :id, :name, :category, :theme, :created, :archived, :account_id

  @live_db = PG.connect(dbname: 'todo_list')
  @test_db = PG.connect(dbname: 'todo_list_test')
  @new_list = '
    INSERT INTO todo_lists
    (name, category, theme, created, archived, account_id)
    VALUES($1, $2, $3, $4, $5, $6)
    RETURNING id, name, category, theme, created, archived, account_id;'
  @edit_list = '
    UPDATE todo_lists
    SET name = $2, category = $3, theme = $4
    WHERE id = $1
    RETURNING id, name, category, theme, created, archived, account_id;'
  @delete_list = '
    DELETE FROM todo_lists
    WHERE id = $1
    RETURNING id, name, category, theme, created, archived, account_id;'
  @get_lists = "SELECT * FROM todo_lists;"
  @get_info = "SELECT * FROM todo_lists WHERE id = $1;"

  def initialize(id:, name:, category:, theme:, created:, archived:, account_id:)
    @id = id
    @name = name
    @category = category
    @theme = theme
    @created = created
    @archived = archived
    @account_id = account_id
  end

  def self.create(name:, category:, theme:, created:, archived:, account_id:)
    ENV['ENVIRONMENT'] == 'test' ? connection = @test_db : connection = @live_db
    result = connection.exec_params(@new_list, [name, category, theme, created, archived, account_id])
    List.new(
      id: result[0]['id'],
      name: result[0]['name'],
      category: result[0]['category'],
      theme: result[0]['theme'],
      created: result[0]['created'],
      archived: result[0]['archived'],
      account_id: result[0]['account_id'])
  end
  
  def self.all
    ENV["ENVIRONMENT"] == "test" ? connection = @test_db : connection = @live_db
    result = connection.exec_params(@get_lists)
    result.map do |list|
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
    ENV["ENVIRONMENT"] == "test" ? connection = @test_db : connection = @live_db
    result = connection.exec_params(@get_info, [id])
    List.new(
      id: result[0]['id'],
      name: result[0]['name'],
      category: result[0]['category'],
      theme: result[0]['theme'],
      created: result[0]['created'],
      archived: result[0]['archived'],
      account_id: result[0]['account_id'])
  end

  def self.edit(id:, name:, category:, theme:)
    ENV["ENVIRONMENT"] == "test" ? connection = @test_db : connection = @live_db
    result = connection.exec_params(@edit_list, [id, name, category, theme])
    List.new(
      id: result[0]['id'],
      name: result[0]['name'],
      category: result[0]['category'],
      theme: result[0]['theme'],
      created: result[0]['created'],
      archived: result[0]['archived'],
      account_id: result[0]['account_id'])
  end

  def self.delete(id:)
    ENV["ENVIRONMENT"] == "test" ? connection = @test_db : connection = @live_db
    result = connection.exec_params(@delete_list, [id])
    List.new(
      id: result[0]['id'],
      name: result[0]['name'],
      category: result[0]['category'],
      theme: result[0]['theme'],
      created: result[0]['created'],
      archived: result[0]['archived'],
      account_id: result[0]['account_id'])
  end

end
