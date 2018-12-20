require 'bcrypt'

module PasswordHelper
  def self.encrypted_password(password = nil)
    password ||= default_password
    BCrypt::Password.create(password, cost: 4)
  end

  def self.default_password
    'alpahbravo'
  end
end
