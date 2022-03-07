require 'sinatra/base'
require './lib/user'

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

  run! if app_file == $0
end
