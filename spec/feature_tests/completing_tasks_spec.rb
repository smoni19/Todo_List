require 'timecop'

feature 'user can set task to completed' do
  before do Timecop.freeze(Time.local(2022, 3, 9, 13, 0, 0)) end
  after do Timecop.return end
  future_time = Time.local(2022, 4, 9, 13, 0, 0)

  scenario 'users creates a task and can check the checkbox to signal that it is complete' do
    visit('/')
    user = User.create(username: 'sj19', email: 'sj19@test.com', password: '1234')
    todo_list = List.create(name: 'House jobs', category: 'DIY', created: Time.new, archived: 'False', account_id: user.id)
    task = Task.create(details: 'Put up shelves', deadline: future_time, completed: 'False', todo_list_id: todo_list.id)
    click_link('Log in')
    fill_in('username', with: 'sj19')
    fill_in('password', with: '1234')
    click_button('Login')
    expect(page.status_code).to eq 200
    expect(page).to have_current_path('/')
    find("#checkbox#{task.id}").set(true)
    expect(task.completed).to eq 'f'
  end
end

