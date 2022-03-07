feature 'user can sign up' do
  scenario 'user fills out sign up form, click Sign Up! button and their account is created' do
    visit('/')
    expect(page).to have_content 'Sign up'
    click_link('Sign up')
    fill_in('username', with: 'sj19')
    fill_in('email', with: 'sj@exmple.com')
    fill_in('password', with: '1234')
    click_button('Sign up!')
    expect(page).to have_content('Hello sj19')
    expect(page.status_code).to eq 200
  end
end
