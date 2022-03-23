module MainController
  module Routes
    class Index < Sinatra::Base

      configure do
        set :views, 'app/views/index'
      end

      get '/' do
        @username = session[:username]
        @my_lists = List.all
        @my_tasks = Task.all
        @my_subtasks = Subtask.all
        erb :'index'
      end

    end
  end
end
