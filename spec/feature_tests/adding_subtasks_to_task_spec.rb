feature 'user can add subtasks to a task' do
  scenario 'users can add subtask to a task in a similar way to adding a task to a list' do
    visit('/')
    user = User.create(username: 'sj19', email: 'sj19@test.com', password: '1234')
    click_link('Log in')
    fill_in('username', with: 'sj19')
    fill_in('password', with: '1234')
    click_button('Login')
    fill_in('List name', with: 'House jobs')
    fill_in('Category', with: 'DIY')
    click_button('Create list')
    expect(page.status_code).to eq 200
    expect(page).to have_current_path('/')
    expect(page).to have_content 'House jobs'
    expect(page).to have_content 'DIY'
    fill_in('Task details', with: 'Put up shelves')
    fill_in('Deadline', with: '2022-04-01')
    click_button('Add')
    expect(page.status_code).to eq 200
    expect(page).to have_current_path('/')
    within "form#new_subtask" do
      fill_in('Subtask details', with: 'Buy shelves')
      fill_in('Deadline', with: '2022-04-03')
      click_button('Add')
      fill_in('Subtask details', with: 'Screw shelves to wall')
      fill_in('Deadline', with: '2022-04-05')
      click_button('Add')
    end
    expect(page.status_code).to eq 200
    expect(page).to have_current_path('/')
    expect(page).to have_content 'Buy shelves'
    expect(page).to have_content 'Deadline: 2022-04-03'
    expect(page).to have_content 'Screw shelves to wall'
    expect(page).to have_content 'Deadline: 2022-04-05'
  end
end
