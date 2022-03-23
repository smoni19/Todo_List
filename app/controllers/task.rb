require 'sinatra/base'
require './lib/classes/task'

module MainController
  module Routes
    class TaskContoller < Sinatra::Base

      configure do
        set :views, 'app/views/task'
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
        erb :"edit"
      end
  
      patch '/task/:id/update' do
        Task.edit(id: params[:id], details: params[:edited_details], deadline: params[:edited_deadline])
        redirect '/my_todo_lists'
      end
  
      delete '/task/:id/delete' do
        Task.delete(id: params[:id])
        redirect '/'
      end

    end
  end
end