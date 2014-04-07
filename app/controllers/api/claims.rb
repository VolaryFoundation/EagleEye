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
          claim.user = User.find(session[:user_id])
          claim.eagle_id = req['eagle_id']
          claim.status = 'pending'
          if claim.save
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
