require 'sinatra/base'
require 'sinatra/reloader'

require './app/controllers/index'
require './app/controllers/user'
require './app/controllers/todo_list'
require './app/controllers/task'
require './app/controllers/subtask'

module MainController
  class TodoList < Sinatra::Base
    configure :development do
      register Sinatra::Reloader
    end
    enable :sessions, :method_override

    use Routes::Index
    use Routes::UserContoller
    use Routes::ListContoller
    use Routes::TaskContoller
    use Routes::SubtaskContoller

    run! if app_file == $0
  end
end
