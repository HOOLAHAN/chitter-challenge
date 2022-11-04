# (in lib/peep_repository.rb)

require_relative './peep'

class PeepRepository

  def all
    sql = 'SELECT id, timestamp, content, user_id FROM peeps;'
    result_set = DatabaseConnection.exec_params(sql, [])
    peeps = []
    result_set.each do |record|
      peep = Peep.new
      peep.id = record['id']
      peep.timestamp = record['timestamp']
      peep.content = record['content']
      peep.user_id = record['user_id']
      peeps << peep
    end
    return peeps
  end

  def find(id)
    sql = 'SELECT id, timestamp, content, user_id FROM peeps WHERE id = $1;'
    params = [id]
    result_set = DatabaseConnection.exec_params(sql, params)
    record = result_set[0]
    peep = Peep.new
    peep.id = record['id']
    peep.timestamp = record['timestamp']
    peep.content = record['content']
    peep.user_id = record['user_id']
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