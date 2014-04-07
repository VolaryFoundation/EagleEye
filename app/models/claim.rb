class Claim

  include MongoMapper::Document

  belongs_to :user

  STATUS_OPTIONS = ['pending', 'active', 'rejected', 'deactive']

  timestamps!
  key :eagle_id, required: true
  key :user_id, required: true
  key :status, required: true

end
