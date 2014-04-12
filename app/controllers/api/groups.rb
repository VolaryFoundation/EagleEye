require APP_ROOT + "/models/group"
require 'digest/md5'
require 'uri'


module SC
  module API
    class GroupsController < ApiBaseController

      get "/" do
        ok RestClient.get("http://volary-eagle-staging.herokuapp.com/entities")
      end



      post "/:id/delete" do
        user = User.find(session[:user_id])
        @group = Group.find(params[:id])
        if user.present? && (@group.user == @user || user.role = 'admin')
          @group.deleted = true
          if @group.update_attributes(params[:group])
            ok @group.to_json
          else
            @group.attributes = params[:group]
            no_post @group.to_json
          end
        else
          no_save
        end
      end




      
    end
  end
end
