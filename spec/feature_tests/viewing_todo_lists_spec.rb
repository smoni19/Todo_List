feature "user can create todo list" do
  scenario "users click My todo lists and are taken to a page where they can see their lists" do
    visit("/")
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
    click_link('New todo list')
    fill_in('List name', with: 'Car')
    click_button('Create todo list')
    click_link('My todo lists')
    expect(page.status_code).to eq 200
    expect(page).to have_content 'House jobs'
    expect(page).to have_content 'DIY'
    expect(page).to have_content 'Car'
  end
end
