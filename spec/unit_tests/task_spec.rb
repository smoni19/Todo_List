require 'timecop'

describe Task do
  before do Timecop.freeze(Time.local(2022, 3, 9, 13, 0, 0)) end
  after do Timecop.return end
  future_time = Time.local(2022, 4, 9, 13, 0, 0)

  describe '#create' do
    it 'creates a new task which takes name, category and id of poster' do
      user = User.create(username: 'sj19', email: 'sj19test.com', password: '1234')
      todo_list = List.create(name: 'House jobs', category: 'DIY', theme: '#00aaff', created: Time.new, archived: 'False', account_id: user.id)
      task1 = Task.create(details: 'Put up shelves', deadline: future_time, completed: 'False', todo_list_id: todo_list.id)
      task2 = Task.create(details: 'Paint bureau', deadline: future_time, completed: 'False', todo_list_id: todo_list.id)
      expect(task1).to be_a Task
      expect(task1.details).to eq 'Put up shelves'
      expect(task1.deadline).to eq '2022-04-09 13:00:00+00'
      expect(task1.completed).to eq 'f'
      expect(task1.todo_list_id).to eq todo_list.id
    end
  end

  describe '#all' do
    it 'returns all created tasks' do
      user = User.create(username: 'sj19', email: 'sj19test.com', password: '1234')
      todo_list = List.create(name: 'House jobs', category: 'DIY', theme: '#00aaff', created: Time.new, archived: 'False', account_id: user.id)
      task1 = Task.create(details: 'Put up shelves', deadline: future_time, completed: 'False', todo_list_id: todo_list.id)
      task2 = Task.create(details: 'Paint bureau', deadline: future_time, completed: 'False', todo_list_id: todo_list.id)
      all_tasks = Task.all
      expect(all_tasks.length).to eq 2
      expect(all_tasks[0].details).to eq 'Put up shelves'
      expect(all_tasks[1].details).to eq 'Paint bureau'
    end
  end

  describe '#set_status' do
    it 'sets completed status to either TRUE or FALSE' do
      user = User.create(username: 'sj19', email: 'sj19test.com', password: '1234')
      todo_list = List.create(name: 'House jobs', category: 'DIY', theme: '#00aaff', created: Time.new, archived: 'False', account_id: user.id)
      task = Task.create(details: 'Put up shelves', deadline: future_time, completed: 'False', todo_list_id: todo_list.id)
      completed_task = Task.set_status(id: task.id, completed: 't')
      expect(completed_task.completed).to eq 'f'
      completed_task = Task.set_status(id: task.id, completed: 'f')
      expect(completed_task.completed).to eq 't'
    end
  end
  
  describe "#edit" do
    it "edits the details of a task" do
      user = User.create(username: 'sj19', email: 'sj19test.com', password: '1234')
      todo_list = List.create(name: 'House jobs', category: 'DIY', theme: '#00aaff', created: Time.new, archived: 'False', account_id: user.id)
      task = Task.create(details: 'Put up shelves', deadline: future_time, completed: 'False', todo_list_id: todo_list.id)
      edited_task = Task.edit(id: task.id, details: 'Paint bureau', deadline: future_time)
      expect(edited_task.details).to eq 'Paint bureau'
      expect(edited_task.deadline).to eq '2022-04-09 13:00:00+00'
    end
  end
  
  describe "#delete" do
    it "deletes a task and removes it from tasks array" do
      user = User.create(username: 'sj19', email: 'sj19test.com', password: '1234')
      todo_list = List.create(name: 'House jobs', category: 'DIY', theme: '#00aaff', created: Time.new, archived: 'False', account_id: user.id)
      task = Task.create(details: 'Put up shelves', deadline: future_time, completed: 'False', todo_list_id: todo_list.id)
      Task.delete(id: task.id)
      tasks = Task.all
      expect(tasks.length).to eq 0
    end
  end
  
  describe "#check_for_link" do
    it "checks text for valid link format and returns a link" do
      user = User.create(username: 'sj19', email: 'sj19test.com', password: '1234')
      todo_list = List.create(name: 'House jobs', category: 'DIY', theme: '#00aaff', created: Time.new, archived: 'False', account_id: user.id)
      task = Task.create(details: 'Look for shelves on [Wickes]{https://www.wickes.co.uk/}', deadline: future_time, completed: 'False', todo_list_id: todo_list.id)
      Task.delete(id: task.id)
      expect(task.check_for_link(task.details)).to eq "Look for shelves on <a href=\"https://www.wickes.co.uk/\">Wickes</a>"
    end
  end

end
