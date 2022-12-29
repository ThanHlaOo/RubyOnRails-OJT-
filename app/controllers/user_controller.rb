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
    session[:user] ||= {}
    [:email, :name, :password, :password_confirmation, :address, :dob, :role, :phone].each do |attribute|
      session[:user][attribute] = @user.send(attribute)
      puts "session"
    end
    # @user.profile = register_params[:profile].open

    if @user.valid?
      if register_params[:profile]
        @name = register_params[:profile].original_filename
        @user_name = register_params[:name]
        @file_name = @user_name+@name
        path = File.join("app", "assets", "images", @file_name)
        # @user.profile.attach(register_params[:profile])
        File.open(path, "wb") { |f| f.write(register_params[:profile].read) }
      end

      render :confirmRegister
      # redirect_to "/user/registerConfirm"
    else 
      render :register
    end
   
  end
  def cancle
    @file_name = params[:name]
    @user = session[:user]
    @file_path = URI.decode_www_form_component(@file_name)+".png"

    path = File.join("app", "assets", "images", @file_path)
    if File.delete(path)
      redirect_to "/users/new"
    else 
      render :confirmRegister
    end
    
  end
  def saveRegister
    puts "this is register meethod"
    @user = User.new(register_params)
    @user.create_user_id = session[:user_id]
    @user.updated_user_id = session[:user_id]
    if session[:user]
      session.delete(:user)
    end
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
    key_name = search_params[:name]
    key_email = search_params[:email]
    key_to = search_params[:to_date]
    key_from = search_params[:from_date]
    # @users = User.where("name LIKE ? OR email LIKE ?", "%#{key_name}%", "%#{key_email}%")
    @users = User.all
    @users = @users.where("UPPER(name) LIKE UPPER(:name)", name: "%#{key_name}%") if key_name.present?
    @users = @users.where("UPPER(email) LIKE UPPER(:email)", email: "%#{key_email}%") if key_email.present?
    @users = @users.where(created_at: key_from..key_to) if key_from.present? && key_to.present?
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
  def edit_password
    @user = User.find(session[:user_id])
  end
  def update_password
    if password_params[:current_password].blank? || password_params[:password].blank? || password_params[:password_confirmation].blank?
      if password_params[:current_password].blank?
        flash[:current_password] = "Current Password can't be blank."
      end
      if password_params[:password].blank?
        flash[:password] = "New Password can't be blank."
      end
      if password_params[:password_confirmation].blank?
        flash[:password_confirmation] = "New Confirm Password can't be blank."
      end
      redirect_to '/password/edit'
      return
    end
    @user = User.find(session[:user_id])
    if !@user.authenticate(password_params[:current_password])
      flash[:incorrect_password] = "Current Password is Wrong!"
      redirect_to "/password/edit"
      return
    elsif password_params[:password] != password_params[:password_confirmation]
      flash[:confirmation_error] = "New Password and New Confirm Password confirmation is not match."
      puts "not match"
      redirect_to "/password/edit"
      return
    end
  
    if @user.update(password_params)
      redirect_to "/users", notice: 'Password is successfully updated.'
      return
    else
      puts "error"
      redirect_to "/password/edit", notice: "not updated"
      return
    end
  end
  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
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
    params.require(:keyword).permit(:name, :email, :from_date, :to_date)
  end
end
