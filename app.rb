require 'sinatra/base'
require './lib/user'
require './lib/list'
require './lib/task'

class TodoList < Sinatra::Base
  enable :sessions, :method_override

  get '/' do
    @username = session[:username]
    @my_lists = List.all
    @my_tasks = Task.all
    erb :index
  end

  get '/signup' do
    erb :'user/new'
  end

  post '/signup' do
    @user = User.create(
      username: params[:username],
      email: params[:email],
      password: params[:password])
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
    erb :index
  end

  post '/new_todo_list' do
    List.create(
      name: params[:name],
      category: params[:category],
      theme: params[:theme],
      created: Time.new,
      archived: "False",
      account_id: session[:id])
    redirect '/'
  end

  get '/my_todo_lists' do
    @my_lists = List.all
    @my_tasks = Task.all
    redirect '/'
  end

  post '/new_task' do
    Task.create(
      details: params[:details],
      deadline: params[:deadline],
      completed: "False",
      todo_list_id: params[:list_id])
    redirect '/my_todo_lists'
  end

  post '/task/:id/:status' do
    Task.set_status(id: params[:id], completed: params[:status])
    redirect '/my_todo_lists'
  end

  get '/task/:id/edit' do
    @task = Task.find(id: params[:id])
    erb :"task/edit"
  end

  patch '/task/:id/update' do
    Task.edit(id: params[:id], details: params[:edited_details], deadline: params[:edited_deadline])
    redirect '/my_todo_lists'
  end

  delete '/task/:id/delete' do
    Task.delete(id: params[:id])
    redirect '/'
  end

  get '/list/:id/edit' do
    @list = List.find(id: params[:id])
    erb :"list/edit"
  end

  patch '/list/:id/update' do
    List.edit(id: params[:id], name: params[:edited_name], category: params[:edited_category], theme: params[:edited_theme])
    redirect '/'
  end

  delete '/list/:id/delete' do
    List.delete(id: params[:id])
    redirect '/'
  end

  run! if app_file == $0
end

