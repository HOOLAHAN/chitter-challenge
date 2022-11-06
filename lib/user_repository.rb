# (in lib/user_repository.rb)

require_relative './user'

class UserRepository

  # def sign_in(email, submitted_password)
  #   user = find_by_email(email)
  #   return nil if user.nil?
  #   # Compare the submitted password with the encrypted one saved in the database
  #   if submitted_password == BCrypt::Password.new(user.password)
  #     return true
  #   else
  #     return false
  #   end
  # end

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

  def find_by_email(email)
    sql = 'SELECT id, name, email, username, password FROM users WHERE email = $1;'
    params = [email]
    result_set = DatabaseConnection.exec_params(sql, params)
    record = result_set.first
    user = User.new
    user.id = record['id']
    user.name = record['name']
    user.email = record['email']
    user.username = record['username']
    user.password = record['password']
    return user
  end

  def create(new_user)
    sql = 'INSERT INTO users (name, email, username, password) VALUES ($1, $2, $3, $4);'
    # encrypted_password = BCrypt::Password.create(new_user.password)
    params = [new_user.name, new_user.email, new_user.username, new_user.password]
    result_set = DatabaseConnection.exec_params(sql, params)
    # user_id = result_set[0]["id"]
    return new_user
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
