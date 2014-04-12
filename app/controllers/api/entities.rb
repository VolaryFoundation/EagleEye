require APP_ROOT + "/models/group"
require 'digest/md5'
require 'uri'


module SC
  module API
    class EntitiesController < ApiBaseController

      get "/:id" do
        begin
          group = RestClient.get("http://localhost:3000/entities/#{params[:id]}", :accept => :json)
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
        digest = Digest::MD5.hexdigest("#{time}3df603b1883a43b7b793a8b61e1544cbebb7d78f")
        begin
          group = RestClient.post(URI.escape("http://localhost:3000/entities?authTimestamp=#{time}&authHash=#{digest}&authId=eagle-eye"), post_request, :content_type => :json, :accept => :json
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
          digest = Digest::MD5.hexdigest("#{time}3df603b1883a43b7b793a8b61e1544cbebb7d78f")
          begin
            group = RestClient.put(URI.escape("http://localhost:3000/entities/#{params[:id]}?authTimestamp=#{time}&authHash=#{digest}&authId=eagle-eye"), post_request, :content_type => :json, :accept => :json
){ |response, request, result, &block| response }
          rescue => e
            group = e
          end
          if group.code == 200
            created group
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
          digest = Digest::MD5.hexdigest("#{time}3df603b1883a43b7b793a8b61e1544cbebb7d78f")
          group = RestClient.delete(URI.escape("http://localhost:3000/entities/#{params[:id]}?authTimestamp=#{time}&authHash=#{digest}&authId=eagle-eye"), :content_type => :json, :accept => :json){ |response, request, result, &block| response }
          debugger
          ok '{}'.to_json
        else
          no_save
        end
      end



    end
  end
end

