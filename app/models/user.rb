class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at email encrypted_password first_name id id_value last_name
       remember_created_at reset_password_sent_at reset_password_token updated_at]
  end
end
