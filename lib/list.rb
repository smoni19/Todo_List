require 'pg'

class List
  attr_reader :id, :name, :category, :created, :archived, :account_id

  @live_db = PG.connect(dbname: 'todo_list')
  @test_db = PG.connect(dbname: 'todo_list_test')
  @new_list = '
    INSERT INTO todo_lists
    (name, category, created, archived, account_id)
    VALUES($1, $2, $3, $4, $5)
    RETURNING id, name, category, created, archived, account_id;'

  def initialize(id:, name:, category:, created:, archived:, account_id:)
    @id = id
    @name = name
    @category = category
    @created = created
    @archived = archived
    @account_id = account_id
  end

  def self.create(name:, category:, created:, archived:, account_id:)
    ENV['ENVIRONMENT'] == 'test' ? connection = @test_db : connection = @live_db
    result = connection.exec_params(@new_list, [name, category, created, archived, account_id])
    List.new(
      id: result[0]['id'],
      name: result[0]['name'],
      category: result[0]['category'],
      created: result[0]['created'],
      archived: result[0]['archived'],
      account_id: result[0]['account_id'])
  end
  
end
