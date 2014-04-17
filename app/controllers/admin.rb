require APP_ROOT + "/models/claim"

module SC
  class AdminController < BaseController
    get "/" do
      @group_claims = Claim.all(:status => 'pending')
      haml :"admin/index"
    end
  end
end
