require 'spec_helper'
require 'rack/test'
require_relative '../../app'
require 'bcrypt'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods
  # We need to declare the `app` value by instantiating the Application class so our tests work.
  let(:app) { Application.new }

  context '/' do
    it 'should redirect to the homepage/feed' do
      response = get('/')
      expect(response.status).to eq (302)
    end
  end
  
  context "GET /feed" do
    it "should display the HTML content containing a list of peeps" do
      response = get('/feed')
      expect(response.status).to eq (200)
      expect(response.body).to include ('<p>A peep with some content</p>')
    end
  end

  context "GET /login" do
    it "should display the HTML content containing the user log in form" do
      response = get('/login')
      expect(response.status).to eq (200)
      expect(response.body).to include ('<h3>Please enter login details below:</h3>')
    end
  end

  context "POST /login" do
    it 'lets the user log in' do
      response = post('/login', email: 'simon@test.com', password: 'simon123')
      expect(response.status).to eq (302)
      get_response = get('/feed')
      expect(get_response.status).to eq (200)
      expect(get_response.body).to include('Post a new Peep')
      expect(get_response.body).to include('Logout')
    end
  end

  context "GET /login_error" do
    it "should display the HTML content containing a message to the user" do
      response = get('/login_error')
      expect(response.status).to eq (200)
      expect(response.body).to include ('<h1>Login error!</h1>')
      expect(response.body).to include ('<a href="/login">Return to login page</a><br />')
    end
  end

  context 'GET /logout' do
    it 'should display the HTML content containing a message to the user' do
      response = get('/logout')
      expect(response.status).to eq (200)
      expect(response.body).to include ('<h1>Goodbye!</h1>')
      expect(response.body).to include ('<a href="/login">Login</a>')
    end
  end

  context "GET /feed/new" do
    it "should display the HTML content containing the new peep form" do
      response = get('/feed/new')
      expect(response.status).to eq (200)
      expect(response.body).to include ('<form action="/feed" method="POST">')
      expect(response.body).to include ('<label>Write peep content</label>')
    end
  end

  context "GET /feed/:id" do
    it "should display the HTML content containing a single peep" do
    response = get('/feed/1')
      expect(response.status).to eq (200)
      expect(response.body).to include ('<h1>1</h1>')
      expect(response.body).to include ('A peep with some content')
    end
  end

  context "POST /feed" do
    it "creates a new peep" do
      login_response = post('/login', email: 'simon@test.com', password: 'simon123')
      expect(login_response.status).to eq (302)
      response = post('/feed', content: 'Test peep')
      expect(response.status).to eq (302)
      get_response = get('/feed')
      expect(get_response.body).to include ('Test peep')
    end
  end

  context "GET /new_user" do
    it "should display the HTML content containing the create new user form" do
      response = get('/new_user')
      expect(response.status).to eq (200)
      expect(response.body).to include ('<form action="/new_user" method="POST">')
    end
  end

  context "GET /new_user_added" do
    it "should display the HTML content containing the create new user form" do
      response = get('/new_user_added')
      expect(response.status).to eq (200)
      expect(response.body).to include ('<h1>Account added - Welcome to Chitter!</h1>')
    end
  end

  context "POST /new_user" do
    it "should create a new user" do
      response = post('/new_user', name: "Sandra Brown", email: 'sandra@test.com', username: 'user_sandra', password: 'sandra123')
      expect(response.status).to eq (200)
    end
  end
end