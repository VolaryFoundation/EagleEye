require APP_ROOT + "/helpers/abbreviation_helper.rb"


module SC
  class GroupsController < BaseController
  
    get "/" do
      begin
        @groups = JSON.parse(RestClient.get "#{ENV['EAGLE_SERVER']}entities?limit=3000")
      rescue
        @groups = nil
      end
      haml :"groups/index"
    end
    
    get "/map" do
      results = Geocoder.search(request.ip)
      state = (results.first.state.present? ? results.first.state : 'Colorado')
      @url = "#{ENV['WIDGET_SERVER']}groups-map.html?filters[subject]=groups&filters[keys][location.state]=#{abbreviate(state)}&size=645x600"
      haml :'groups/map'
    end

    get "/new" do
       haml :"groups/new"
    end

    get "/:id" do
      @claims = Claim.find_all_by_eagle_id(params[:id])
      haml :"groups/show"
    end
  end
end
