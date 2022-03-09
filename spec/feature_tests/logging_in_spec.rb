feature "user can log in" do
  scenario "users fill out log in form, click Login! button and they are logged in" do
    visit("/")
    expect(page).to_not have_content("Logout")
    user = User.create(username: 'sj19', email: 'sj19@test.com', password: '1234')
    click_link('Log in')
    fill_in('username', with: 'sj19')
    fill_in('password', with: '1234')
    click_button('Login')
    expect(page.status_code).to eq 200
    expect(page).to have_content("Hello sj19")
    expect(page).to have_content("Logout")
  end
end
