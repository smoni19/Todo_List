require 'timecop'

feature 'user can edit a subtask' do
  before do Timecop.freeze(Time.local(2022, 3, 9, 13, 0, 0)) end
  after do Timecop.return end
  future_time = Time.local(2022, 4, 9, 13, 0, 0)

  scenario 'users creates a subtask and can edit it upon clicking Edit button' do
    visit('/')
    user = User.create(username: 'sj19', email: 'sj19@test.com', password: '1234')
    todo_list = List.create(name: 'House jobs', category: 'DIY', theme: '#00aaff', created: Time.new, archived: 'False', account_id: user.id)
    task = Task.create(details: 'Put up shelves', deadline: future_time, completed: 'False', todo_list_id: todo_list.id)
    subtask = Subtask.create(details: 'Screw shelves to wall', deadline: future_time, completed: 'False', task_id: task.id)
    click_link('Log in')
    fill_in('username', with: 'sj19')
    fill_in('password', with: '1234')
    click_button('Login')
    expect(page.status_code).to eq 200
    expect(page).to have_current_path('/')
    within "li#subtask_#{subtask.id}" do
      click_button('Edit')
    end
    expect(page.status_code).to eq 200
    expect(page).to have_current_path("/subtask/#{subtask.id}/edit")
    fill_in(:edited_details, with: 'Buy shelves')
    click_button('Update Subtask')
    expect(page.status_code).to eq 200
    expect(page).to have_current_path('/')
    expect(page).to_not have_content('Screw shelves to wall')
    expect(page).to have_content('Buy shelves')
    expect(page).to have_content('2022-04-09')
  end

end
