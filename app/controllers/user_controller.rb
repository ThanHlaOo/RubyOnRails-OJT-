class UserController < ApplicationController
  def index
  end
  def login
    @user = User.new
  end
  
  def create
    if login_params[:email].blank?
      flash[:login_email_errors] = ['Email is required']
      puts flash[:login_email_errors]
      redirect_to '/login'
      return
    end
    
    if login_params[:password].blank?
      flash[:login_password_errors] = ['Password is required']
      redirect_to '/login'
      return
    end 
    if login_params[:password].length < 6
      flash[:login_password_errors] = ['Password length is minimun 6']
      redirect_to '/login' 
      return
    end
    @user = User.find_by(email: login_params[:email])
    if @user && @user.authenticate(login_params[:password])
      session[:user_id] = @user.id
      redirect_to '/posts'

    elsif !@user 
      flash[:login_errors] = ['Email does not Exit!']
      redirect_to '/login'
    else
      flash[:login_errors] = ['Incorrect Password!']
      redirect_to '/login'
    end 
  end
  def register

  end

  def saveRegister
    @user = User.new(register_params)
  
    if @user.save
       session[:user_id] = @user.id
       redirect_to '/'
    else
      flash[:register_errors] = @user.errors.full_messages
      redirect_to '/register'
    end
  end
  def logout 
    session[:user_id] = nil
    redirect_to '/login'
  end
  private
  def register_params
    params.require(:user).permit(:name, :email, :password)
  end
  private
  def login_params
    params.require(:login).permit(:email, :password)
  end
end
