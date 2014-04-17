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
