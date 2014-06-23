require APP_ROOT + "/models/user"

module SC
  class UsersController < BaseController
  
    get "/new" do
      @user = User.new
      haml :"users/new"
    end
    
    put "/create" do
      @user = User.new(params[:user])
      if params[:user][:password] == params[:user][:password_confirmation]
        if @user.save
          session[:user_id] = @user.id
          flash[:notice] = "You have signed up and are now logged in."
          redirect "../groups"
        else
          flash[:alert] = "Unable to sign you up"
          haml :"users/new"
        end
      else
        flash[:alert] = "Password must match the confirmation"
        redirect "users/new"
      end
    end 
  end
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
