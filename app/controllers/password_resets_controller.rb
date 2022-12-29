class PasswordResetsController < ApplicationController
    def new 
    end
    def create
        user = User.find_by_email(register_params[:email])
        user.send_password_reset if user
        flash[:notice] = ['E-mail sent with password reset instructions.']
        redirect_to new_password_reset_path
    end
    def edit
        @user = User.find_by_password_reset_token!(params[:id])
      end
      
      def update
        @user = User.find_by_password_reset_token!(params[:id])
        if @user.password_reset_sent_at < 2.hours.ago
          redirect_to new_password_reset_path, :alert => "Password reset has expired."
        elsif @user.update(reset_params)
          redirect_to login_path, :notice => "Password has been reset!"
        else
          render :edit
        end
      end
    private
    def register_params
        params.require(:user).permit(:email)
    end
    private 
    def reset_params
        params.require(:user).permit(:password, :password_confirmation)
    end
end