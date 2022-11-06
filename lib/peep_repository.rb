# (in lib/peep_repository.rb)

require_relative './peep'

class PeepRepository

  def all
    sql = 'SELECT peeps.id AS peep_id, timestamp, content, user_id, name, username FROM peeps JOIN users ON user_id = users.id;'
    result_set = DatabaseConnection.exec_params(sql, [])
    peeps = []
    result_set.each do |record|
      peep = Peep.new
      peep.id = record['peep_id']
      peep.timestamp = record['timestamp']
      peep.content = record['content']
      peep.user_id = record['user_id']
      peeps << peep
    end
    return peeps
  end

  def find(id)
    sql = 'SELECT peeps.id AS peep_id, timestamp, content, user_id, users.id AS users_id, name, username FROM peeps JOIN users ON user_id = users.id WHERE peeps.id = $1;'
    params = [id]
    result_set = DatabaseConnection.exec_params(sql, params)
    record = result_set[0]
    peep = Peep.new
    peep.id = record['peep_id'].to_i
    peep.timestamp = record['timestamp']
    peep.content = record['content']
    peep.user_id = record['user_id'].to_i
    peep.users_id = record['users_id'].to_i
    peep.username = "@#{record['username']}"
    return peep
  end

  def create(peep)
    sql = 'INSERT INTO peeps (timestamp, content, user_id) VALUES ($1, $2, $3);'
    params = [peep.timestamp, peep.content, peep.user_id]
    result_set = DatabaseConnection.exec_params(sql, params)
    return nil
  end

  def delete(peep)
    sql = 'DELETE FROM peeps WHERE id = $1;'
    sql_params = [peep]
    DatabaseConnection.exec_params(sql, sql_params)
    return nil
  end

end
