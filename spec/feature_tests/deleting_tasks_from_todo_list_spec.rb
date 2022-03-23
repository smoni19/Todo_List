feature 'user can add task and delete it' do
  scenario 'users can delete tasks' do
    visit('/')
    user = User.create(username: 'sj19', email: 'sj19@test.com', password: '1234')
    click_link('Log in')
    fill_in('username', with: 'sj19')
    fill_in('password', with: '1234')
    click_button('Login')
    fill_in('List name', with: 'House jobs')
    fill_in('Category', with: 'DIY')
    click_button('Create list')
    fill_in('Task details', with: 'Put up shelves')
    fill_in('Deadline', with: '2022-04-01')
    click_button('Add')
    expect(page).to have_current_path('/')
    expect(page).to have_content 'Put up shelves'
    expect(page).to have_content 'Deadline: 2022-04-01'
    within "form#delete_list" do
      click_button('Delete')
    end
    expect(page.status_code).to eq 200
    expect(page).to have_current_path('/')
    expect(page).not_to have_content 'Put up shelves'
    expect(page).not_to have_content 'Deadline: 2022-04-01'
  end
end
