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
