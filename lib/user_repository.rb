# (in lib/user_repository.rb)

require_relative './user'

class UserRepository

  def all
    sql = 'SELECT id, name, email, username, password FROM users;'
    result_set = DatabaseConnection.exec_params(sql, [])
    users = []
    result_set.each do |record|
      user = User.new
      user.id = record['id']
      user.name = record['name']
      user.email = record['email']
      user.username = record['username']
      user.password = record['password']
      users << user
    end
    return users
  end

  def find(id)
    sql = 'SELECT id, name, email, username, password FROM users WHERE id = $1;'
    params = [id]
    result_set = DatabaseConnection.exec_params(sql, params)
    record = result_set[0]
    user = User.new
    user.id = record['id']
    user.name = record['name']
    user.email = record['email']
    user.username = record['username']
    user.password = record['password']
    return user
  end

  def create(user)
    sql = 'INSERT INTO users (name, email, username, password) VALUES ($1, $2, $3, $4);'
    params = [user.name, user.email, user.username, user.password]
    result_set = DatabaseConnection.exec_params(sql, params)
    return nil
  end

  def update(user)
    sql = 'UPDATE users SET name = $1, email = $2, username = $3, password = $4 WHERE id = $5;'
    params = [user.name, user.email, user.username, user.password, user.id]
    result_set = DatabaseConnection.exec_params(sql, params)
    return nil
  end

  def delete(user)
    sql = 'DELETE FROM users WHERE id = $1;'
    sql_params = [user]
    DatabaseConnection.exec_params(sql, sql_params)
    return nil
  end

end