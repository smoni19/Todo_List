require 'user'

describe User do
  describe '#create' do
    it 'creates a new user' do
      user = User.create(username: 'sj19', email: 'sj19@test.com', password: '1234')
      expect(user).to be_a User
      expect(user.username).to eq 'sj19'
      expect(user.email).to eq 'sj19@test.com'
    end
  end

  describe '#login' do
    it 'logs in a user if they have signed up' do
      user = User.create(username: 'sj19', email: 'sj19@test.com', password: '1234')
      user = User.login(username: 'sj19', password: '1234')
      expect(user.username).to eq 'sj19'
    end
  end

end
