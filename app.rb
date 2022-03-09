require 'sinatra/base'
require './lib/user'
require './lib/list'
require './lib/task'

class TodoList < Sinatra::Base
  enable :sessions

  get '/' do
    @username = session[:username]
    erb :index
  end

  get '/signup' do
    erb :'user/new'
  end

  post '/signup' do
    @user = User.create(
      username: params[:username],
      email: params[:email],
      password: params[:password]
    )
    session[:username] = @user.username
    session[:email] = @user.email
    session[:id] = @user.id
    redirect '/'
  end

  get '/login' do
    erb :'user/login'
  end

  post '/login' do
    @user = User.login(username: params[:username], password: params[:password])
    session[:username] = @user.username
    session[:email] = @user.email
    session[:id] = @user.id
    redirect '/'
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/new_todo_list' do
    erb :"list/new"
  end

  post '/new_todo_list' do
    List.create(
      name: params[:name],
      category: params[:category],
      created: Time.new,
      archived: "False",
      account_id: session[:id])
    redirect '/my_todo_lists'
  end

  get '/my_todo_lists' do
    @my_lists = List.all
    @my_tasks = Task.all
    erb :"list/my_lists"
  end

  post '/new_task' do
    Task.create(
      details: params[:details],
      deadline: params[:deadline],
      completed: "False",
      todo_list_id: params[:list_id])
    redirect '/my_todo_lists'
  end

  run! if app_file == $0
end
