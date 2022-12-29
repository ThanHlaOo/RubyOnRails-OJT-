class User < ApplicationRecord
    has_secure_password
    has_one_attached :profile
    attribute :current_password, :string
    validates :name, presence: true
    validates :email, presence: true
    # validates :profile, 
    validates :password, presence: true, length: { minimum: 6 }
    validates :password_confirmation, presence: true 
    has_many :posts
   
   validates_confirmation_of :password
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
#    validates_format_of :email, with: VALID_EMAIL_REGEX
   # validates :password, confirmation: true, unless: -> { password.blank? }
    validates :email, presence: true, length: { maximum: 255 },format: { with: VALID_EMAIL_REGEX },uniqueness: { case_sensitive: false }
    
    # validates :phone, numericality: {only_integer: true}, length: {is: 10 , message: "length should be 10"} 
    def send_password_reset
        generate_token(:password_reset_token)
        self.password_reset_sent_at = Time.zone.now
        save!
        UserMailer.forgot_password(self).deliver# This sends an e-mail with a link for the user to reset the password
      end
      # This generates a random password reset token for the user
    def generate_token(column)
    begin
        self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
    end
end
