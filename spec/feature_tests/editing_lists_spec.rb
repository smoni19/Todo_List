feature 'user can edit lists' do
  scenario 'users can edit lists' do
    visit('/')
    user = User.create(username: 'sj19', email: 'sj19@test.com', password: '1234')
    todo_list = List.create(name: 'House jobs', category: 'DIY', theme: '#00aaff', created: Time.new, archived: 'False', account_id: user.id)
    click_link('Log in')
    fill_in('username', with: 'sj19')
    fill_in('password', with: '1234')
    click_button('Login')
    expect(page).to have_content 'House jobs'
    within "form#edit_list" do
      click_button('Edit')
    end
    expect(page.status_code).to eq 200
    expect(page).to have_current_path("/list/#{todo_list.id}/edit")
    fill_in('edited_name', with: 'Garden jobs')
    fill_in('edited_category', with: 'DIY')
    click_button('Update list')
    expect(page).not_to have_content 'House jobs'
    expect(page).to have_content 'Garden jobs'
    expect(page).to have_content 'DIY'
  end
end
