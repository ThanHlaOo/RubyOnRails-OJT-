class User < ApplicationRecord
    has_secure_password
    has_one_attached :profile
    validates :name, presence: true
    validates :email, presence: true
    # validates :profile, 
    validates :password, presence: true, length: { minimum: 6 }, on: :create
    validates :password_confirmation, presence: true, on: :create
    has_many :posts
   
   validates_confirmation_of :password
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
#    validates_format_of :email, with: VALID_EMAIL_REGEX
   # validates :password, confirmation: true, unless: -> { password.blank? }
    validates :email, presence: true, length: { maximum: 255 },format: { with: VALID_EMAIL_REGEX },uniqueness: { case_sensitive: false }
    
    # validates :phone, numericality: {only_integer: true}, length: {is: 10 , message: "length should be 10"} 
end
