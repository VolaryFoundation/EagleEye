require APP_ROOT + "/models/group"

module SC
  module API
    class GroupsController < ApiBaseController

      get "/" do
        ok Group.search(params)
      end

      get "/:id" do
        group = JSON.parse(RestClient.get("http://api.secularconnect.org/groups/#{params[:id]}"))
        if group.to_json
          ok group
        else
          missing
        end
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


      post "/:id" do
        user = User.find(session[:user_id])
        @group = Group.find(params[:id])
        if user.present? && (@group.user == @user || user.role = 'admin')
          if params['group']['location'].present? 
            result = Geocoder.search(location_to_html(params[:group][:location])).first
            params[:group][:location][:lng_lat] = [result.longitude, result.latitude]
          end
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


      post "/:id/add_url" do
        user = User.find(session[:user_id])
        group = Group.find(params[:id])
        link = Link.new(params[:link])
        link.name = link.url
        if user.present? && (group.user == user || user.role = 'admin')
          if group.add_url(link)
            ok "[#{group.to_json},#{link.to_json}]"
          else
            debugger
            no_save group.to_json
          end
        else
          no_save
        end
      end

      post "/:group_id/url/:url_id" do
        user = User.find(session[:user_id])
        @group = Group.find(params[:group_id])
        link =  @group.links.find(params[:url_id])
        link.url = params[:link][:url]
        link.name = params[:link][:url]
        link.type = params[:link][:type]
        if user.present? && (@group.user == @user || user.role = 'admin')
          if link.save
            ok link.to_json
          else
            @group.attributes = params[:group]
            no_post @group.to_json
          end
        else
          no_save
        end
      end

      post "/:group_id/delete_url/:url_id" do
        user = User.find(session[:user_id])
        @group = Group.find(params[:group_id])
        link =  @group.links.find(params[:url_id])
        @group.links.delete_if{|l| l.id  == link.id}
        if user.present? && (@group.user == @user || user.role = 'admin')
          if @group.save
            ok link.to_json
          else
            # Figure out what to do for an error
          end
        else
          no_save
        end
      end

    end
  end
end
