use Rack::Static, :urls => ['/stylesheets', '/javascripts', '/fonts', '/bower_components', '/images'], :root => 'public'
require './app/boot'
Rack::MethodOverride

map "/" do
  run SC::MainController
end

map "/api/events" do
  run SC::API::EntitiesController
end

map "/api/groups" do
  run SC::API::EntitiesController
end

map "/api/entities" do
  run SC::API::EntitiesController
end


map "/api/claims" do
  run SC::API::ClaimsController
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
