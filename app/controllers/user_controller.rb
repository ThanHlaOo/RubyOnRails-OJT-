class UserController < ApplicationController
  
  before_action :check_permissions, only: [:index, :register, :confirmRegister, :saveRegister]
  def index
    @users = User.all
  end
  def login
    @user = User.new
  end
  
  def create
    if login_params[:email].blank?
      flash[:login_email_errors] = ["Email can't be blank."]
      if login_params[:password].blank?
        flash[:login_password_errors] = ["Password can't be blank."]
      end
      redirect_to '/login'
      return
    end
    if !login_params[:email].match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i) && !login_params[:email].blank?
      flash[:login_email_errors] = ["Email Format is invalid"]
      if login_params[:password].blank?
        flash[:login_password_errors] = ["Password can't be blank."]
      end
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
    @user = User.new
  end

  def confirmRegister
    @user = User.new(register_params)
    # @user = User.create!(register_params)
    @user.create_user_id = session[:user_id]
    @user.updated_user_id = session[:user_id]
    # @user.profile = register_params[:profile].open
    # @user.profile.attach(register_params[:profile])
    if @user.valid?
      if register_params[:profile]
        @name = register_params[:profile].original_filename
        @user_name = register_params[:name]
        @file_path = @user_name+@name
        path = File.join("app", "assets", "images", @file_path)
        File.open(path, "wb") { |f| f.write(register_params[:profile].read) }
      end
      render :confirmRegister
    else 
      render :register
    end
   
  end
  def cancle
    puts "this is cancle"
    @file_path = params[:user][:path]
    path = File.join("app", "assets", "images", @file_path)
    if File.delete(path)
      render :register
    end
  end
  def saveRegister
    puts "this is register meethod"
    @user = User.new(register_params)
    puts register_params
    @user.create_user_id = session[:user_id]
    @user.updated_user_id = session[:user_id]
    @user.profile.attach(register_params[:profile])
    if @user.save
       flash[:user_created] = ["User Created Successfully."]
       redirect_to '/users'
    else
      # flash[:register_errors] = @user.errors.full_messages
      # redirect_to '/register'
      render :register
    end
  end

  def profile 
    @user = User.find(session[:user_id])
  end
  def editProfile
    @user = User.find(params[:id])
    puts "this is edit"
    puts @user
  end
  def updateProfile
    # puts "this is updateprofile"
    # puts edit_profile_params
    @user = User.find(params[:id])
    if  @user.update(edit_profile_params)
      flash[:user_updated] = ['User profile Successfully Updated.']
      redirect_to "/users"
    else
      @user =  @user.errors
      render :editProfile
    end
  end
  def search
    key = params[:user][:keyword]
    @posts = Post.where("title LIKE ? OR description LIKE ?", "%#{key}%", "%#{key}%")
    render :index
  end
  def destroy
    puts "delete method"
    @user = User.find(params[:id])
    @user.destroy
    flash[:user_deleted] = ['User Successfully Deleted.']
    redirect_to "/users"
  end
  def logout 
    session[:user_id] = nil
    redirect_to '/login'
  end
  private
  def register_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :phone, :dob, :address, :profile)
  end
  private
  def edit_profile_params
    params.require(:user).permit(:name, :email, :role, :phone, :dob, :address, :profile)
  end
  private
  def login_params
    params.require(:login).permit(:email, :password)
  end
  private
  def check_permissions
    unless session[:user_id]
      redirect_to "/login"
    end
  end
  private
  def search_params
    params.require(:user).permit(:email, :name, :from, :to)
  end
end
