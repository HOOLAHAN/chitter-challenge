# file: spec/peep_repository_spec.rb

require 'peep_repository'
require 'peep'

def reset_peeps_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_challenge_test' })
  connection.exec(seed_sql)
end
describe PeepRepository do
  before(:each) do 
    reset_peeps_table
  end
  
  it 'Gets all peeps' do
    repo = PeepRepository.new
    peeps = repo.all
    expect(peeps.length).to eq  8
    expect(peeps[0].id).to eq  '1'
    expect(peeps[0].timestamp).to eq  '2022-11-04 12:41:50'
    expect(peeps[0].content).to eq  'A peep with some content'
    expect(peeps[0].user_id).to eq '1'
    expect(peeps[1].id).to eq  '2'
    expect(peeps[1].timestamp).to eq  '2022-01-02 18:30:10'
    expect(peeps[1].content).to eq  'A peep with some more content'
    expect(peeps[1].user_id).to eq '1'
  end

  it 'finds a peep' do
    repo = PeepRepository.new
    peeps = repo.find(1)
    expect(peeps.timestamp).to eq '2022-11-04 12:41:50'
    expect(peeps.content).to eq 'A peep with some content'
    expect(peeps.user_id).to eq '1'
  end
  
  it 'creates a peep' do
    repo = PeepRepository.new
    new_peep = Peep.new
    new_peep.timestamp = '2022-11-04 15:41:00'
    new_peep.content = 'some new content'
    new_peep.user_id = '1'
    repo.create(new_peep) #=> nil
    peeps = repo.all
    last_peep = peeps.last
    expect(last_peep.timestamp).to eq '2022-11-04 15:41:00'
    expect(last_peep.content).to eq 'some new content'
    expect(last_peep.user_id).to eq '1'
  end

  it 'deletes a peep' do
    repo = PeepRepository.new
    repo.delete(1)
    result_set = repo.all
    expect(result_set.length).to eq 7
    expect(result_set.first.id).to eq '2'
  end
end