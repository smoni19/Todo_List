require 'sinatra/base'
require './lib/classes/user'

module MainController
  module Routes
    class UserContoller < Sinatra::Base

      configure do
        set :views, 'app/views/user'
      end

      get '/signup' do
        erb :'new'
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
        erb :'login'
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

    end
  end
end
