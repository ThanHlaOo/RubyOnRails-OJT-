class User < ApplicationRecord
    has_secure_password

    validates :name, presence: true
    validates :email, presence: true
   validates :password, presence: true, length: { minimum: 6 }
#    validates_confirmation_of :user_name, :password
   # validates :password, confirmation: true, unless: -> { password.blank? }
    # validates :email, presence: true, length: { maximum: 255 },format: { with: VALID_EMAIL_REGEX },uniqueness: { case_sensitive: false }
    
    # validates :phone, numericality: {only_integer: true}, length: {is: 10 , message: "length should be 10"} 
end
