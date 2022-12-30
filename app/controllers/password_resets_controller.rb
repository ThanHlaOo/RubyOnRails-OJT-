class PasswordResetsController < ApplicationController
    def new 
    end
    def create
      if register_params[:email].blank?
        flash[:email_validation_errors] = "Email can't be blank."
        redirect_to new_password_reset_path
        return
      end
      if !register_params[:email].match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i) 
        flash[:email_validation_errors] = "Email Format is invalid"
        redirect_to new_password_reset_path
        return
      end
        user = User.find_by_email(register_params[:email])
        if user 
          user.send_password_reset if user
          flash[:notice] = 'E-mail sent with password reset instructions.'
        else
          flash[:alert] = 'Email does not Exists'
        end
     
        redirect_to new_password_reset_path
    end
    def edit
        @user = User.find_by_password_reset_token!(params[:id])
    end
      
      def update
        if reset_params[:password].blank? ||  reset_params[:password_confirmation].blank? 
          if reset_params[:password].blank? 
            flash[:password_validation_errors] = "Password can't be blank."
          end
          if  reset_params[:password_confirmation].blank? 
            flash[:confirm_password_validation_errors] = "Password confirmation can't be blank."
          end
          redirect_to edit_password_reset_path
          return
        end
        if reset_params[:password] != reset_params[:password_confirmation]
          flash[:confirmation_error] = "Password and Password confirmation are not match."
          redirect_to edit_password_reset_path
          return
        end
        @user = User.find_by_password_reset_token!(params[:id])
    
        if @user.password_reset_sent_at < 2.hours.ago
          redirect_to edit_password_reset_path, :alert => "Password reset has expired."
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