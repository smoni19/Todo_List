feature 'user can delete lists' do
  scenario 'users can delete lists' do
    visit('/')
    user = User.create(username: 'sj19', email: 'sj19@test.com', password: '1234')
    click_link('Log in')
    fill_in('username', with: 'sj19')
    fill_in('password', with: '1234')
    click_button('Login')
    fill_in('List name', with: 'House jobs')
    fill_in('Category', with: 'DIY')
    click_button('Create list')
    within "form#delete_list" do
      click_button('Delete')
    end
    expect(page).not_to have_content 'House jobs'
    expect(page).not_to have_content 'DIY'
  end
end
