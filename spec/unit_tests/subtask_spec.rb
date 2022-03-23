require 'timecop'

describe Subtask do
  before do Timecop.freeze(Time.local(2022, 3, 9, 13, 0, 0)) end
  after do Timecop.return end
  future_time = Time.local(2022, 4, 9, 13, 0, 0)

  describe '#create' do
    it 'creates a new subtask which takes details, deadline, completed and id of list' do
      user = User.create(username: 'sj19', email: 'sj19test.com', password: '1234')
      todo_list = List.create(name: 'House jobs', category: 'DIY', theme: '#00aaff', created: Time.new, archived: 'False', account_id: user.id)
      task = Task.create(details: 'Put up shelves', deadline: future_time, completed: 'False', todo_list_id: todo_list.id)
      subtask = Subtask.create(details: 'Buy shelves', deadline: future_time, completed: 'False', task_id: task.id)
      expect(subtask).to be_a Subtask
      expect(subtask.details).to eq 'Buy shelves'
      expect(subtask.deadline).to eq '2022-04-09 13:00:00+00'
      expect(subtask.completed).to eq 'f'
      expect(subtask.task_id).to eq task.id
    end
  end

  describe '#all' do
    it 'returns all created subtasks' do
      user = User.create(username: 'sj19', email: 'sj19test.com', password: '1234')
      todo_list = List.create(name: 'House jobs', category: 'DIY', theme: '#00aaff', created: Time.new, archived: 'False', account_id: user.id)
      task = Task.create(details: 'Put up shelves', deadline: future_time, completed: 'False', todo_list_id: todo_list.id)
      subtask1 = Subtask.create(details: 'Buy shelves', deadline: future_time, completed: 'False', task_id: task.id)
      subtask2 = Subtask.create(details: 'Screw shelves to wall', deadline: future_time, completed: 'False', task_id: task.id)
      all_subtasks = Subtask.all
      expect(all_subtasks.length).to eq 2
      expect(all_subtasks[0].details).to eq 'Buy shelves'
      expect(all_subtasks[1].details).to eq 'Screw shelves to wall'
    end
  end

  describe '#set_status' do
    it 'sets completed status to either TRUE or FALSE' do
      user = User.create(username: 'sj19', email: 'sj19test.com', password: '1234')
      todo_list = List.create(name: 'House jobs', category: 'DIY', theme: '#00aaff', created: Time.new, archived: 'False', account_id: user.id)
      task = Task.create(details: 'Put up shelves', deadline: future_time, completed: 'False', todo_list_id: todo_list.id)
      subtask = Subtask.create(details: 'Buy shelves', deadline: future_time, completed: 'False', task_id: task.id)
      completed_subtask = Subtask.set_status(id: subtask.id, completed: 't')
      expect(completed_subtask.completed).to eq 'f'
      completed_subtask = Subtask.set_status(id: subtask.id, completed: 'f')
      expect(completed_subtask.completed).to eq 't'
    end
  end
  
  describe "#edit" do
    it "edits the details of a subtask" do
      user = User.create(username: 'sj19', email: 'sj19test.com', password: '1234')
      todo_list = List.create(name: 'House jobs', category: 'DIY', theme: '#00aaff', created: Time.new, archived: 'False', account_id: user.id)
      task = Task.create(details: 'Put up shelves', deadline: future_time, completed: 'False', todo_list_id: todo_list.id)
      subtask = Subtask.create(details: 'Screw shelves to wall', deadline: future_time, completed: 'False', task_id: task.id)
      edited_subtask = Subtask.edit(id: subtask.id, details: 'Buy shelves', deadline: future_time)
      expect(edited_subtask.details).to eq 'Buy shelves'
      expect(edited_subtask.deadline).to eq '2022-04-09 13:00:00+00'
    end
  end
  
  describe "#delete" do
    it "deletes a subtask and removes it from tasks array" do
      user = User.create(username: 'sj19', email: 'sj19test.com', password: '1234')
      todo_list = List.create(name: 'House jobs', category: 'DIY', theme: '#00aaff', created: Time.new, archived: 'False', account_id: user.id)
      task = Task.create(details: 'Put up shelves', deadline: future_time, completed: 'False', todo_list_id: todo_list.id)
      subtask = Subtask.create(details: 'Screw shelves to wall', deadline: future_time, completed: 'False', task_id: task.id)
      Subtask.delete(id: subtask.id)
      subtasks = Subtask.all
      expect(subtasks.length).to eq 0
    end
  end
  
  describe "#check_for_link" do
    it "checks text for valid link format and returns a link" do
      user = User.create(username: 'sj19', email: 'sj19test.com', password: '1234')
      todo_list = List.create(name: 'House jobs', category: 'DIY', theme: '#00aaff', created: Time.new, archived: 'False', account_id: user.id)
      task = Task.create(details: 'Buy shelves', deadline: future_time, completed: 'False', todo_list_id: todo_list.id)
      subtask = Subtask.create(details: 'Look for shelves on [Wickes]{https://www.wickes.co.uk/}', deadline: future_time, completed: 'False', task_id: task.id)
      Subtask.delete(id: subtask.id)
      expect(subtask.check_for_link(subtask.details)).to eq "Look for shelves on <a href=\"https://www.wickes.co.uk/\">Wickes</a>"
    end
  end

end
