require 'user'

describe User do
  describe '#create' do
    it 'creates a new user' do
      user = User.create(username: 'js2000', email: 'js2000@test.com', password: '1234')
      expect(user).to be_a User
      expect(user.username).to eq 'js2000'
      expect(user.email).to eq 'js2000@test.com'
    end
  end
end
