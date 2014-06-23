require 'digest/md5'
require 'uri'


module SC
  module API
    class EntitiesController < ApiBaseController

      get "/:id" do
        begin
          group = RestClient.get("#{ENV['EAGLE_SERVER']}entities/#{params[:id]}", :accept => :json)
        rescue => e
          e
        end
        if group.present?
          ok group
        else
          missing
        end
      end

      post "/" do
        post_request = request.env["rack.input"].read
        time = Time.now()
        time = time.to_s.gsub('+', ' ')
        digest = Digest::MD5.hexdigest("#{time}#{ENV['EAGLE_API']}")
        begin
          group = RestClient.post(URI.escape("#{ENV['EAGLE_SERVER']}entities?authTimestamp=#{time}&authHash=#{digest}&authId=eagle-eye"), post_request, :content_type => :json, :accept => :json
){ |response, request, result, &block| response }
        rescue => e
          group = e
        end
        if group.code == 201
          created group
        else
          failed group
        end
      end

      put "/:id" do
        user = User.find(session[:user_id])
        if user.present? && (Claim.approved_claim?(user.id, params[:id]) || user.role = 'admin')
          post_request = request.env["rack.input"].read
          time = Time.now()
          time = time.to_s.gsub('+', ' ')
          digest = Digest::MD5.hexdigest("#{time}#{ENV['EAGLE_API']}")
          begin
            group = RestClient.put(URI.escape("#{ENV['EAGLE_SERVER']}entities/#{params[:id]}?authTimestamp=#{time}&authHash=#{digest}&authId=eagle-eye"), post_request, :content_type => :json, :accept => :json
){ |response, request, result, &block| response }
          rescue => e
            group = e
          end
          if group.code == 200
            ok group
          else
            failed group
          end
        else
          no_save
        end
      end

      delete "/:id" do
        user = User.find(session[:user_id])
        if user.present? && (Claim.approved_claim?(user.id, params[:id]) || user.role = 'admin')
          time = Time.now()
          time = time.to_s.gsub('+', ' ')
          digest = Digest::MD5.hexdigest("#{time}#{ENV['EAGLE_API']}")
          group = RestClient.delete(URI.escape("#{ENV['EAGLE_SERVER']}entities/#{params[:id]}?authTimestamp=#{time}&authHash=#{digest}&authId=eagle-eye"), :content_type => :json, :accept => :json){ |response, request, result, &block| response }
          ok '{}'.to_json
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
