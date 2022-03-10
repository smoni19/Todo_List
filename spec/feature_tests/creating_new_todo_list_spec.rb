feature 'user can create todo list' do
  scenario 'users click Create new todo list which appears on the page' do
    visit('/')
    user = User.create(username: 'sj19', email: 'sj19@test.com', password: '1234')
    click_link('Log in')
    fill_in('username', with: 'sj19')
    fill_in('password', with: '1234')
    click_button('Login')
    fill_in('List name', with: 'House jobs')
    fill_in('Category', with: 'DIY')
  end
end

