require 'sinatra/base'
require './lib/classes/subtask'

module MainController
  module Routes
    class SubtaskContoller < Sinatra::Base

      configure do
        set :views, 'app/views/subtask'
      end

      post '/new_subtask' do
        Subtask.create(
          details: params[:details],
          deadline: params[:deadline],
          completed: "False",
          task_id: params[:task_id])
        redirect '/my_todo_lists'
      end
      
      post '/subtask/:id/:status' do
        Subtask.set_status(id: params[:id], completed: params[:status])
        redirect '/my_todo_lists'
      end
      
      get '/subtask/:id/edit' do
        @subtask = Subtask.find(id: params[:id])
        erb :"edit"
      end
      
      patch '/subtask/:id/update' do
        Subtask.edit(id: params[:id], details: params[:edited_details], deadline: params[:edited_deadline])
        redirect '/my_todo_lists'
      end
      
      delete '/subtask/:id/delete' do
        Subtask.delete(id: params[:id])
        redirect '/'
      end

    end
  end
end
