class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    puts "Before Sending password reset email to #{user.email}" 
    # mail :to => user.email, :subject => "Password Reset"
    mail(to: user.email, subject: 'Password Reset')
    def deliver_later
      processed_mailer = Mailer.new(self)
      message = processed_mailer.message
      processed_mailer.handle_exceptions do
        message.deliver_later
      end
    end
  end
end
