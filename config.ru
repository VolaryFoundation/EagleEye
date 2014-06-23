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

##=========================================================================##
## This file is part of EagleEye.                                          ##
##                                                                         ##
## EagleEye is Copyright 2014 Volary Foundation and Contributors           ##
##                                                                         ##
## EagleEye is free software: you can redistribute it and/or modify it     ##
## under the terms of the GNU Affero General Public License as published   ##
## by the Free Software Foundation, either version 3 of the License, or    ##
## at your option) any later version.                                      ##
##                                                                         ##
## EagleEye is distributed in the hope that it will be useful, but         ##
## WITHOUT ANY WARRANTY; without even the implied warranty of              ##
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU       ##
## Affero General Public License for more details.                         ##
##                                                                         ##
## You should have received a copy of the GNU Affero General Public        ##
## License along with EagleEye.  If not, see                               ##
## <http://www.gnu.org/licenses/>.                                         ##
##=========================================================================##
