feature 'user can add tasks to a todo list' do
  scenario 'users fill out new Task form, providing details and optional deadline and task appears in associated list when Add task button is clicked ' do
    visit('/')
    user = User.create(username: 'sj19', email: 'sj19@test.com', password: '1234')
    click_link('Log in')
    fill_in('username', with: 'sj19')
    fill_in('password', with: '1234')
    click_button('Login')
    click_link('New todo list')
    fill_in('List name', with: 'House jobs')
    fill_in('Category', with: 'DIY')
    click_button('Create todo list')
    expect(page.status_code).to eq 200
    expect(page).to have_current_path('/my_todo_lists')
    expect(page).to have_content 'House jobs'
    expect(page).to have_content 'DIY'
    fill_in('Task details', with: 'Put up shelves')
    fill_in('Deadline', with: '2022-04-01')
    click_button('Add task')
    expect(page.status_code).to eq 200
    expect(page).to have_current_path('/my_todo_lists')
    expect(page).to have_content 'Put up shelves'
    expect(page).to have_content 'Deadline: 2022-04-01'
  end
end
