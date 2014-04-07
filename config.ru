use Rack::Static, :urls => ['/stylesheets', '/javascripts', '/fonts', '/bower_components', '/images'], :root => 'public'
require './app/boot'
Rack::MethodOverride

map "/" do
  run SC::MainController
end

map "/api/events" do
  run SC::API::EventsController
end

map "/api/groups" do
  run SC::API::GroupsController
end

map "/api/claims" do
  run SC::API::ClaimsController
end


map "/events" do
  run SC::EventsController
end

map "/groups" do
  run SC::GroupsController
end

map "/users" do
  run SC::UsersController
end

map "/password_reset" do
  run SC::PasswordResetController
end

map "/admin" do
  run SC::AdminController
end
