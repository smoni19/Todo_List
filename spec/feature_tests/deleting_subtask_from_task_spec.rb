feature 'user can delete subtasks' do
  scenario 'users can delete a subtask which they have added to a task' do
    visit('/')
    user = User.create(username: 'sj19', email: 'sj19@test.com', password: '1234')
    todo_list = List.create(name: 'House jobs', category: 'DIY', theme: '#00aaff', created: Time.new, archived: 'False', account_id: user.id)
    task = Task.create(details: 'Put up shelves', deadline: '2022-04-07', completed: 'False', todo_list_id: todo_list.id)
    subtask1 = Subtask.create(details: 'Buy shelves', deadline: '2022-04-03', completed: 'False', task_id: task.id)
    subtask2 = Subtask.create(details: 'Screw shelves to wall', deadline: '2022-04-05', completed: 'False', task_id: task.id)
    click_link('Log in')
    fill_in('username', with: 'sj19')
    fill_in('password', with: '1234')
    click_button('Login')
    within "li#subtask_#{subtask1.id}" do
      click_button('Delete')
    end
    expect(page.status_code).to eq 200
    expect(page).to have_current_path('/')
    expect(page).to_not have_content 'Buy shelves'
    expect(page).to_not have_content 'Deadline: 2022-04-03'
    expect(page).to have_content 'Screw shelves to wall'
    expect(page).to have_content 'Deadline: 2022-04-05'
  end
end
