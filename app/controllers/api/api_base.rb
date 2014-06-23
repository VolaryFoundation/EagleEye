module SC
  module API
    class ApiBaseController < SC::BaseController
    
      before do
        content_type :json
        headers['Access-Control-Allow-Origin'] = '*'
      end
    
      def ical data
        content_type :"text/calendar"
        status 200
        halt data.to_ical
      end

      def created data
        status 201
        return halt data if data
        halt
      end
    
      def ok data
        status 200
        return halt data if data
        halt
      end

      def failed data
        status 406
        return halt data if data
        halt
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
