feature 'user can create list' do
  scenario 'users can fill in new list form and list appears on index page when creted' do
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
    fill_in('List name', with: 'Car')
    click_button('Create list')
    expect(page.status_code).to eq 200
    expect(page).to have_current_path('/')
    expect(page).to have_content 'House jobs'
    expect(page).to have_content 'DIY'
    expect(page).to have_content 'Car'
  end
end
