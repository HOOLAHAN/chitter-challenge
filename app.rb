# File: app.rb

require_relative 'lib/database_connection'
require 'sinatra/base'
require "sinatra/reloader"
require './lib/peep'
require './lib/peep_repository'
require './lib/user'
require './lib/user_repository'

DatabaseConnection.connect

class Application < Sinatra::Base

  enable :sessions

  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/peep_repository'
    also_reload 'lib/user_repository'
  end

  get '/' do
    redirect '/feed'
  end

  get '/login' do
    return erb(:login)
  end

  post '/login' do
    email = params[:email]
    submitted_password = params[:password]
    user = UserRepository.new.find_by_email(email)
    if submitted_password == user.password
      session[:user_id] = user.id
      session[:name] = user.name
      session[:username] = user.username
      redirect('/feed')
    else
      return erb(:login_error)
    end
  end

  get '/login_error' do
    return erb(:login_error)
  end

  get '/logout' do
    session[:user_id] = nil
    return erb(:goodbye)
  end

  get '/feed/new' do
    return erb(:new_peep)
  end

  get '/feed' do
    repo = PeepRepository.new
    @peeps = repo.all
    user_repo = UserRepository.new
    @users = user_repo.all
    return erb(:feed)
  end

  get '/feed/:id' do
    peep_repo = PeepRepository.new
    user_repo = UserRepository.new
    @peep = peep_repo.find(params[:id])
    @user = user_repo.find(@peep.user_id)
    @date = @peep.timestamp.split(' ').first
    @time = @peep.timestamp.split(' ').last.split(':').slice(0,2).join(':')
    return erb(:peep)
  end

  post '/feed' do
    repo = PeepRepository.new
    @new_peep = Peep.new
    @new_peep.content = params[:content]
    @new_peep.timestamp = Time.new
    @new_peep.user_id = session[:user_id]
    repo.create(@new_peep)
    redirect '/'
    # return erb(:feed)
  end

  get '/new_user' do
    return erb(:new_user)
  end

  get '/new_user_added' do
    return erb(:new_user_added)
  end

  post '/new_user' do
    repo = UserRepository.new
    new_user = User.new
    new_user.name = params[:name]
    new_user.email = params[:email]
    new_user.username = params[:username]
    new_user.password = params[:password]

    repo.create(new_user)
    return erb(:new_user_added)
  end

end
