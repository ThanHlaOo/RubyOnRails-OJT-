class UserController < ApplicationController
  def index
  end
  def login
    @user = User.new
  end
  
  def create
    @user = User.find_by(email:login_params[:email])
    if @user && @user.authenticate(login_params[:password])
      session[:user_id] = @user.id
      redirect_to '/articles'

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
    redirect_to '/articles'
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
