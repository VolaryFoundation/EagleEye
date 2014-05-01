require APP_ROOT + "/helpers/abbreviation_helper.rb"


module SC
  class GroupsController < BaseController
  
    get "/" do
      results = Geocoder.search(request.ip)
      state = (results.first.state.present? ? results.first.state : 'Colorado')
      @url = "#{ENV['WIDGET_SERVER']}groups-map.html?filters[subject]=groups&filters[keys][location.state]=#{abbreviate(state)}&size=645x600&viewMode=list"
      haml :'groups/index'
    end
    
    get "/map" do
      results = Geocoder.search(request.ip)
      state = (results.first.state.present? ? results.first.state : 'Colorado')
      @url = "#{ENV['WIDGET_SERVER']}groups-map.html?filters[subject]=groups&filters[keys][location.state]=#{abbreviate(state)}&size=645x600&viewMode=map"
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
