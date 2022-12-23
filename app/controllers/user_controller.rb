class UserController < ApplicationController
  def index
  end
  def login
    @user = User.new
  end
  
  def create

    # if  login_params[:email].present?
    #   flash[:login_errors] = ['']
    #   redirect_to '/login'
    # end
    @user = User.find_by(email: login_params[:email])
    # puts "hello login user"
    # puts @user
    # @user = User.create(name: "user1", email: "email1", password: "sample1")
    # @user.va
    
    # if @user.valid? 

    #   puts "this is valid"
    # else
      
    #   puts @user.errors.full_messages
    #   puts "this is not  valid"
    # end
    
    if @user && @user.authenticate(login_params[:password])
      session[:user_id] = @user.id
      render 'posts/index'

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
