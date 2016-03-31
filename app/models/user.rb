class User < ActiveRecord::Base
  attr_reader :password

  validates :user_name, :password_digest, presence: true
  validates :user_name, uniqueness: true
  validates :password, length: { minimum: 4, allow_nil: true }

  after_initialize :ensure_session_token

  has_many :cats
  has_many :cat_rental_requests
  
  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    if user && user.is_password?(password)
      user
    else
      nil
    end
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password).to_s
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def ensure_session_token
    self.session_token ||= generate_session_token
  end

  def reset_session_token!
    self.session_token = generate_session_token
    save!
  end

  def generate_session_token
    SecureRandom::urlsafe_base64(16)
  end
end
