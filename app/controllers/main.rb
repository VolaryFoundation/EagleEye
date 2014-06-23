module SC
  class MainController < BaseController
    require 'uri'

    get "/" do
      redirect to('/groups')
    end

    get "/status" do
      ok 'Alive'
    end

    get "/login" do ##new
      session[:request_url] = request.referer
      haml :"main/login"
    end
    
    post "/login" do
      user = User.authenticate(params[:user][:email], params[:user][:password])
      if user.present?
        session[:user_id] = user.id
        flash[:notice] = "You are now loged in"
        redirect (session[:request_url] || '/')
      else
        flash[:alert] = "Invalid email or password"
        redirect back
      end
    end 
    
    delete "/logout" do
      session[:user_id] = nil
      flash[:notice] = "You are now loged out"
      uri = URI::parse(request.referer).path
      ok uri.to_json
      #redirect "../groups"
    end

    get "/link_checker" do
      if params[:url].present?
        responce = Link.url_connect?(params[:url])
      end
      ok responce.to_json
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
