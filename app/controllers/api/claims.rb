require APP_ROOT + "/models/claim"
require APP_ROOT + "/models/user"

module SC
  module API
    class ClaimsController < ApiBaseController
      get "/" do
        if params[:search]
          claims = Claim.find_all_by_eagle_id(params[:search])
        else
          claims = Claim.all
        end
        ok claims
      end

      get "/:id" do
        ok Claim.find_by_eagle_id(params[:id])
      end

      post "/" do
        raw_req = request.env["rack.input"].read
        req = JSON.parse(raw_req)
        if session[:user_id].present?
          claim = Claim.new()
          user = User.find(session[:user_id])
          claim.user = user
          claim.user_email = user.email
          claim.eagle_id = req['eagle_id']
          claim.status = 'pending'
          if claim.save
            @url = "http://#{request.host}:#{request.port}/groups/#{claim.eagle_id}"
            Pony.mail(:to => 'netops@volary.org', :subject => 'Group Ownership Claim', :body => haml(:'email/user_claim', layout: false))
            ok claim.to_json
          else
            no_post claim
          end
        else
          no_save
        end
      end

      put "/:id" do
        user = User.find(session[:user_id])
        if user.role == 'admin'
          raw_req = request.env["rack.input"].read
          req = JSON.parse(raw_req)
          claim = Claim.find(params[:id])
          if claim.update_attributes(req)
            ok claim
          else
            no_post claim
          end
        else
          no_save
        end
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
