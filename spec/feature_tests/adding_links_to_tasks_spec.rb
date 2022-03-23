feature 'user can add links to a todo list' do
  scenario 'users fill out new Task form, and provide a link with title in markdown format' do
    visit('/')
    user = User.create(username: 'sj19', email: 'sj19@test.com', password: '1234')
    click_link('Log in')
    fill_in('username', with: 'sj19')
    fill_in('password', with: '1234')
    click_button('Login')
    fill_in('List name', with: 'Research')
    fill_in('Category', with: '')
    click_button('Create list')
    fill_in('Task details', with: '[Visit google]{www.google.com}')
    click_button('Add')
    expect(page.status_code).to eq 200
    expect(page).to have_current_path('/')
    expect(page).to have_content 'Visit google'
    expect(page).not_to have_content '['
    expect(page).to have_selector(:css, 'a[href="www.google.com"]')
  end
end
