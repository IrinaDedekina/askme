require "openssl"
require "uri"

class User < ApplicationRecord
  PROFILE_COLOR_FORMAT = /\A#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/
  USERNAME_FORMAT = /\A[0-9a-zA-Z_]+\z/
  ITERATIONS = 20_000
  DIGEST = OpenSSL::Digest::SHA256.new

  attr_accessor :password

  has_many :questions, :dependent => :destroy

  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true
  validates :password, presence: true, on: :create
  validates_confirmation_of :password
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, length: { maximum: 40 }, format: { with: USERNAME_FORMAT }
  validates :profile_color, format: { with: PROFILE_COLOR_FORMAT}

  before_save :encrypt_password
  before_validation { username.downcase! }

  def encrypt_password
    if password.present?
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
          password, password_salt, ITERATIONS, DIGEST.length, DIGEST
        )
      )
    end
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    user = find_by(email: email)

    return nil unless user.present?

    hashed_password = User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(
        password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
      )
    )

    return user if user.password_hash == hashed_password

    nil
  end
end
