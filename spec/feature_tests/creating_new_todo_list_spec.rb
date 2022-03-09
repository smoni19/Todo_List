feature "user can create todo list" do
  scenario "users click Create new todo list and are taken to a page where they can create a new todo list" do
    visit("/")
    user = User.create(username: 'sj19', email: 'sj19@test.com', password: '1234')
    click_link('Log in')
    fill_in('username', with: 'sj19')
    fill_in('password', with: '1234')
    click_button('Login')
    click_link('New todo list')
    expect(page.status_code).to eq 200
  end
end
