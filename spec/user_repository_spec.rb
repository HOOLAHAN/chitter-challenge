# File: spec/user_repository_spec.rb

require_relative '../lib/user_repository'
require_relative '../lib/user'

def reset_tables
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_challenge_test' })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do 
    reset_tables
  end
  
  it 'Gets all users' do
    repo = UserRepository.new
    users = repo.all
    expect(users.length).to eq 3
    expect(users[0].id).to eq '1'
    expect(users[0].name).to eq 'Simon Smith'
    expect(users[0].email).to eq 'simon@test.com'
    expect(users[0].username).to eq 'user_simon'
    expect(users[0].password).to eq 'simon123'
    expect(users[1].id).to eq '2'
    expect(users[1].name).to eq 'Mary Jones'
    expect(users[1].email).to eq 'mary@test.com'
    expect(users[1].username).to eq 'user_mary'
    expect(users[1].password).to eq 'mary123'
  end

  it 'Gets a single user by id' do
    repo = UserRepository.new
    user = repo.find(1)
    expect(user.id).to eq '1'
    expect(user.name).to eq 'Simon Smith'
    expect(user.email).to eq 'simon@test.com'
    expect(user.username).to eq 'user_simon'
    expect(user.password).to eq 'simon123'
  end

  it 'Gets a single user by email' do
    repo = UserRepository.new
    user = repo.find_by_email('simon@test.com')
    expect(user.id).to eq '1'
    expect(user.name).to eq 'Simon Smith'
    expect(user.email).to eq 'simon@test.com'
    expect(user.username).to eq 'user_simon'
    expect(user.password).to eq 'simon123'
  end

  it 'Creates a user' do
    repo = UserRepository.new
    new_user = User.new
    new_user.name = 'Harry Web'
    new_user.email = 'harry@test.com'
    new_user.username = 'user_harry'
    new_user.password = 'harry123'
    repo.create(new_user) # => nil
    users = repo.all
    last_user = users.last
    expect(last_user.name).to eq 'Harry Web'
    expect(last_user.email).to eq 'harry@test.com'
    expect(last_user.username).to eq 'user_harry'
    expect(last_user.password).to eq 'harry123'
  end

  it 'updates a user' do
    repo = UserRepository.new
    user = repo.find(3)
    user.name = 'Updated Name'
    user.email = 'updated@test.com'
    user.username = 'updated_user'
    user.password = 'updated_password'
    repo.update(user)
    updated_user = repo.find(3)
    expect(updated_user.email).to eq 'updated@test.com'
    expect(updated_user.username).to eq 'updated_user'
    expect(updated_user.name).to eq 'Updated Name'
    expect(updated_user.password).to eq 'updated_password'
  end

    it 'deletes a user' do
    repo = UserRepository.new
    repo.delete(4)
    result_set = repo.all
    expect(result_set.length).to eq 3
    expect(result_set.last.id).to eq '3'
  end

end
