# {{TABLE NAME}} Model and Repository Classes Design Recipe - Chitter-Challange

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `students`*

```
# EXAMPLE
Table: users
Columns:
id | name | email | username | password
Table: peeps
Columns:
id | time | date | content | user_id
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)
-- Write your SQL seed here. 
-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE users RESTART IDENTITY CASCADE;

INSERT INTO users (name, email, username, password) VALUES ('Simon Smith', 'simon@test.com', 'user_simon', 'simon123');
INSERT INTO users (name, email, username, password) VALUES ('Mary Jones', 'mary@test.com', 'user_mary', 'mary123');
INSERT INTO users (name, email, username, password) VALUES ('Wendy McGreggor', 'wendy@test.com', 'user_wendy', 'wendy123');

TRUNCATE TABLE peeps RESTART IDENTITY;

INSERT INTO peeps (timestamp, content, user_id) VALUES ('2022-11-04 12:41:50 +0000', 'A peep with some content', 1);
INSERT INTO peeps (timestamp, content, user_id) VALUES ('2022-01-02 18:30:10 +0000', 'A peep with some more content', 1);
INSERT INTO peeps (timestamp, content, user_id) VALUES ('2022-01-02 19:30:15 +0000', 'A peep with some different content', 1);
INSERT INTO peeps (timestamp, content, user_id) VALUES ('2022-01-02 14:00:05 +0000', 'A peep with some similar content', 2);
INSERT INTO peeps (timestamp, content, user_id) VALUES ('2022-01-02 16:10:00 +0000', 'Another peep with some content', 2);
INSERT INTO peeps (timestamp, content, user_id) VALUES ('2022-01-03 19:35:00 +0000', 'Another peep with some more content', 2);
INSERT INTO peeps (timestamp, content, user_id) VALUES ('2022-01-02 08:30:02 +0000', 'Another peep with some different content', 3);
INSERT INTO peeps (timestamp, content, user_id) VALUES ('2022-01-02 18:30:00 +0000', 'Another peep with some similar content', 3);


```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 chitter_challenge < seeds.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: users
# Model class
# (in lib/user.rb)
class User
end
# Repository class
# (in lib/user_repository.rb)
class UserRepository
end

# Table name: peeps
# Model class
# (in lib/peep.rb)
class Peep
end
# Repository class
# (in lib/peep_repository.rb)
class PeepRepository
end

```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: users
# Model class
# (in lib/user.rb)
class User
  attr_accessor :id, :name, :email, :username, :password
end

# Table name: 
# Model class
# (in lib/peeps.rb)
class Peeps
  attr_accessor :id, :timestamp, :content, :user_id
end


```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: user
# Repository class
# (in lib/user_repository.rb)
class UserRepository
  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, name, email, username, password FROM users;
    # Returns an array of User objects.
  end
  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, name, email, username FROM users WHERE id = $1;
    # Returns a single User object.
  end

  def create(user)
    # Executes the SQL query:
    # 'INSERT INTO users (name, email, username, password) VALUES ($1, $2, $3, $4);'
    # Returns nothing
  end

  def update(user)
    # Executes the SQL query:
    # 'UPDATE users SET name = $1, email = $2, username = $3, password = $4 WHERE id = $5;'
    # Returns nothing
  end

  def delete(user)
    # Executes the SQL query:
    # 'DELETE FROM users WHERE id = $1;'
    # Returns nothing
  end

end

# Table name: peep
# Repository class
# (in lib/peep_repository.rb)
class PeepRepository
  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, timestamp, content, user_id FROM peeps;
    # Returns an array of Peep objects.
  end
  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, timestamp, content, user_id FROM peeps WHERE id = $1;
    # Returns a single Peep object.
  end

  def create(peep)
    # Executes the SQL query:
    # 'INSERT INTO users (timestamp, content, user_id) VALUES ($1, $2, $3);'
    # Returns nothing
  end

  def update(peep)
    # Executes the SQL query:
    # 'UPDATE users SET timestamp = $1, content = $2, user_id_ = $3 WHERE id = $5;'
    # Returns nothing
  end

  def delete(peeps)
    # Executes the SQL query:
    # 'DELETE FROM peeps WHERE id = $1;'
    # Returns nothing
  end

end


```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES
# 1
# Get all users
repo = UserRepository.new
users = repo.all
users.length # =>  3
users[0].id # =>  1
users[0].name # =>  'Simon Smith'
users[0].email # =>  'simon@test.com'
users[0].username # =>  'user_simon'
users[0].password # =>  'simon123'
users[1].id # =>  2
users[1].name # =>  'Mary Jones'
users[1].email # =>  'mary@test.com'
users[1].username # =>  'user_mary'
users[1].password # =>  'mary123'

# 2
# Get a single student
repo = UserRepository.new
user = repo.find(1)
user.id # =>  1
user.name # =>  'Simon Smith'
user.email # =>  'simon@test.com'
user.username # =>  'user_simon'
user.password # =>  'simon123'

# 3
# create a user
repo = UserRepository.new
new_user = User.new
new_user.name = 'Harry Web'
new_user.email = 'harry@test.com'
new_user.username = 'user_harry'
new_user.password = 'harry123'

repo.create(new_user) # => nil

users = repo.all
last_user = users.last
expect(last_user.username).to eq 'Harry Web'
expect(last_user.email).to eq 'harry@test.com'
expect(last_user.username).to eq 'user_harry'
expect(last_user.password).to eq 'harry123'

# 4
# delete a user
repo = UserRepository.new
repo.delete(1)

result_set = repo.all

expect(result_set.length).to eq 2
expect(result_set.first.id).to eq '2'

# 5
# update a user
repo = UserRepository.new
user = repo.find(1)

user.email = 'updated@test.com'
user.username = 'updated_user'
user.name = 'Updated Name'
user.password = 'updated_password'

repo.update(user)

updated_user = repo.find(1)
expect(updated_user.email).to eq 'updated@test.com'
expect(updated_user.username).to eq 'updated_user'
expect(updated_user.name).to eq 'Updated Name'
expect(updated_user.password).to eq 'updated_password'

# 6
# Get all peeps
repo = PeepRepository.new
peeps = repo.all
peeps.length # =>  8
peeps[0].id # =>  1
peeps[0].timestamp # =>  '2022-11-04 12:41:50'
peeps[0].content # =>  'A peep with some content'
peeps[0].user_id # => 1
peeps[1].id # =>  2
peeps[1].timestamp # =>  '2022-01-02 18:30:10'
peeps[1].content # =>  'A peep with some differentcontent'
peeps[1].user_id # => 1

# 7 
# finds a peep
  repo = PeepRepository.new
  peeps = repo.find(1)
  expect(peeps.timestamp).to eq '2022-11-04 12:41:50'
  expect(peeps.content).to eq 'A peep with some content'
  expect(peeps.user_id).to eq '1'

# 8
# creates a peep
repo = PeepRepository.new
new_peep = Post.new
new_peep.timestamp = '2022-11-04 15:41:00'
new_peep.content = 'some new content'
new_peep.user_id = '1'

repo.create(new_peep) #=> nil

peeps = repo.all
last_peep = peeps.last

expect(last_peep.timestamp).to eq '2022-11-04 15:41:00'
expect(last_peep.content).to eq 'some new content'
expect(last_peep.user_id).to eq '1'

# 9
# delete a peep
repo = PeepRepository.new
repo.delete(1)

result_set = repo.all

expect(result_set.length).to eq 7
expect(result_set.first.id).to eq '2'


```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE
# file: spec/user_repository_spec.rb
def reset_users_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_challenge_test' })
  connection.exec(seed_sql)
end
describe UserRepository do
  before(:each) do 
    reset_users_table
  end
  # (your tests will go here).
end

# file: spec/peep_repository_spec.rb
def reset_peeps_table
  seed_sql = File.read('spec/peeps.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_challenge_test' })
  connection.exec(seed_sql)
end
describe PeepRepository do
  before(:each) do 
    reset_peeps_table
  end
  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._