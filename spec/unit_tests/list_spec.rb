require 'timecop'

describe List do
  before do Timecop.freeze(Time.local(2022, 3, 9, 13, 0, 0)) end
  after do Timecop.return end

  describe "#create" do
    it "creates a new list which takes name, category and id of poster" do
      @user = User.create(username: 'sj19', email: 'sj19@test.com', password: '1234')
      @todo_list = List.create(name: 'House jobs', category: 'DIY', created: Time.new, archived: 'False', account_id: @user.id)
      expect(@todo_list).to be_a List
      expect(@todo_list.name).to eq 'House jobs'
      expect(@todo_list.category).to eq 'DIY'
      expect(@todo_list.created).to eq '2022-03-09 12:00:00+00'
      expect(@todo_list.archived).to eq 'f'
      expect(@todo_list.account_id).to eq @user.id
    end
  end
end
