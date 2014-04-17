class Claim

  include MongoMapper::Document

  belongs_to :user

  STATUS_OPTIONS = ['pending', 'active', 'rejected', 'deactive']

  timestamps!
  key :eagle_id, required: true
  key :user_id, required: true
  key :status, required: true
  key :user_email

  def self.approved_claim?(user_id, eagle_id)
    claim = Claim.find_by_user_id_and_eagle_id_and_statue(user_id, eagle_id, 'approved')
    return claim.present? ? true : false
  end

end
