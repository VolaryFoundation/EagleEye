require APP_ROOT + "/helpers/abbreviation_helper.rb"


module SC
  class GroupsController < BaseController
  
    get "/" do
      results = Geocoder.search(request.ip)
      if results.present?
        state = (results.first.state.present? ? results.first.state : 'Colorado')
      else
        state = 'Colorado'
      end
      @url = "#{ENV['WIDGET_SERVER']}groups-map.html?filters[subject]=groups&filters[keys][location.state]=#{abbreviate(state)}&size=645x600&viewMode=list"
      haml :'groups/index'
    end
    
    get "/map" do
      results = Geocoder.search(request.ip)
      if results.present?
        state = (results.first.state.present? ? results.first.state : 'Colorado')
      else
        state = 'Colorado'
      end
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
