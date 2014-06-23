class User
  
  include BCrypt
  include MongoMapper::Document
  
  attr_accessible :email, :password, :password_confirmation
  attr_accessor :password, :password_confirmation

  has_many :claims

  after_validation :encrypt_password

  timestamps!
  key :email, required: true, unique: true
  key :password_hash
  key :password_salt
  key :role, :default => 'user'
  key :password_reset_token
  key :password_reset_expiration
  
  validates :password, :length => { :in => 6..28 }
  
  
  def self.authenticate(email, password)
    user = User.find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
  
  def request_reset_token
    random_string = SecureRandom.base64(24)
    random_string.gsub!('/', 's') #make url acceptable
    self.password_reset_token = random_string
    self.password_reset_expiration = Time.now + 1.day
    self.save!
    return random_string
  end
  
  def clear_token
    self.password_reset_token = nil
    self.password_reset_expiration = nil
    self.save
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
