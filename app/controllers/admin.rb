require APP_ROOT + "/models/claim"

module SC
  class AdminController < BaseController
    get "/" do
      if current_user.present? && current_user.role == 'admin'
        @group_claims = Claim.all(:status => 'pending')
        haml :"admin/index"
      else
        redirect to("../")
      end
    end
  end
end
