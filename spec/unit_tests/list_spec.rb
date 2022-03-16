require 'timecop'

describe List do
  before do Timecop.freeze(Time.local(2022, 3, 9, 13, 0, 0)) end
  after do Timecop.return end

  describe "#create" do
    it "creates a new list which takes name, category and id of poster" do
      user = User.create(username: 'sj19', email: 'sj19test.com', password: '1234')
      todo_list = List.create(name: 'House jobs', category: 'DIY', theme: '#00AAFF', created: Time.new, archived: 'False', account_id: user.id)
      expect(todo_list).to be_a List
      expect(todo_list.name).to eq 'House jobs'
      expect(todo_list.category).to eq 'DIY'
      expect(todo_list.created).to eq '2022-03-09 12:00:00+00'
      expect(todo_list.archived).to eq 'f'
      expect(todo_list.account_id).to eq user.id
    end
  end

  describe "#all" do
    it "returns all created todo lists" do
      user = User.create(username: 'sj19', email: 'sj19test.com', password: '1234')
      todo_list1 = List.create(name: 'House jobs', category: 'DIY', theme: '#00AAFF', created: Time.new, archived: 'False', account_id: user.id)
      todo_list2 = List.create(name: 'Fix car', category: 'Car', theme: '#00AAFF', created: Time.new, archived: 'False', account_id: user.id)
      all_lists = List.all
      expect(all_lists.length).to eq 2
      expect(all_lists[0].name).to eq 'House jobs'
      expect(all_lists[1].category).to eq 'Car'
    end
  end

  describe "#edit" do
    it "edits the name/category/theme of a list" do
      user = User.create(username: 'sj19', email: 'sj19test.com', password: '1234')
      todo_list = List.create(name: 'House jobs', category: 'DIY', theme: '#00AAFF', created: Time.new, archived: 'False', account_id: user.id)
      edited_list = List.edit(id: todo_list.id, name: 'Garden jobs', category: 'DIY', theme: '#00FF44')
      expect(edited_list.name).to eq 'Garden jobs'
      expect(edited_list.category).to eq 'DIY'
      expect(edited_list.theme).to eq '#00FF44'
    end
  end

  describe "#delete" do
    it "deletes a list and removes it from lists array" do
      user = User.create(username: 'sj19', email: 'sj19test.com', password: '1234')
      todo_list = List.create(name: 'House jobs', category: 'DIY', theme: '#00AAFF', created: Time.new, archived: 'False', account_id: user.id)
      List.delete(id: todo_list.id)
      all_lists = List.all
      expect(all_lists.length).to eq 0
    end
  end

end
