require_relative './app/controllers/app'

use Rack::MethodOverride

run MainController::TodoList
