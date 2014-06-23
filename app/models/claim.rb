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
