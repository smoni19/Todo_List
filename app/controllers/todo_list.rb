require 'sinatra/base'
require './lib/classes/list'

module MainController
  module Routes
    class ListContoller < Sinatra::Base

      configure do
        set :views, 'app/views/list'
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

      get '/list/:id/edit' do
        @list = List.find(id: params[:id])
        erb :"edit"
      end
  
      patch '/list/:id/update' do
        List.edit(id: params[:id], name: params[:edited_name], category: params[:edited_category], theme: params[:edited_theme])
        redirect '/'
      end
  
      delete '/list/:id/delete' do
        List.delete(id: params[:id])
        redirect '/'
      end

    end
  end
end
