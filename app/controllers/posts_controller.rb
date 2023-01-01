class PostsController < ApplicationController
  require "csv"
  require 'activerecord-import'
  before_action :check_permissions, only: [:index, :new, :confirm, :edit, :editConfirm, :update, :delete]
  def index
    if User.find(session[:user_id]).role == '1'
      @posts = Post.paginate(page: params[:page], per_page: 10)
    else
      @posts = Post.where(create_user_id: session[:user_id]).paginate(page: params[:page], per_page: 10)
    end
  end
  def new
    @post = Post.new
    # if params

    # else
    #   @post = Post.new(post_params)
      
    # end

    
  end
  def confirm
    @post = Post.new(post_params)
    if post_params[:title].blank?
      flash[:post_title_errors] = ["Title can't be blank."]
      if post_params[:description].blank?
        flash[:post_description_errors] = ["Description can't be blank."]
      end
      if post_params[:description].length > 256
        flash[:post_description_errors] = ["255 characters is the maximum allowed."]
      end
      redirect_to '/posts/new'
      return
    end 
    if post_params[:description].blank?
      flash[:post_description_errors] = ["Description can't be blank."]
      redirect_to '/posts/new'
      return
    end
    if post_params[:description].length > 256
      flash[:post_description_errors] = ["255 characters is the maximum allowed."]
      redirect_to '/posts/new'
      return
    end
   
    # render :new unless @post.valid?
  end
  def create
    @confirm_post = Post.new(confirm_post_params)
    @confirm_post.status = 1
    @confirm_post.create_user_id = session[:user_id]
    @confirm_post.updated_user_id = session[:user_id]
    if @confirm_post.save
      flash[:post_created] = ['Post Successfully Created.']
      redirect_to "/posts"
    else
      @confirm_post =  @confirm_post.errors
      render '/posts/new'

    end

  end 
  def show 
    # @post = Post.find(params[:id])
  end
  def edit
    @post = Post.find(params[:id])
  end
  def editConfirm
    @post =  Post.new(edit_post_params)
    if edit_post_params[:title].blank?
      flash[:post_title_errors] = ["Title can't be blank."]
      if edit_post_params[:description].blank?
        flash[:post_description_errors] = ["Description can't be blank."]
      end
      if edit_post_params[:description].length > 256
        flash[:post_description_errors] = ["255 characters is the maximum allowed."]
      end
      redirect_to edit_post_path(@post)
      return
    end 
    if edit_post_params[:description].blank?
      flash[:post_description_errors] = ["Description can't be blank."]
      redirect_to edit_post_path(@post)
      return
    end
    if edit_post_params[:description].length > 256
      flash[:post_description_errors] = ["255 characters is the maximum allowed."]
      redirect_to edit_post_path(@post)
      return
    end
   
  end
  def update
    @post = Post.find(params[:id])
    params[:status] = 0 unless params[:status] == "on"
    if @post.update(edit_post_params)
      flash[:post_updated] = ['Post Successfully Updated.']
      redirect_to "/posts"
    else
      @post =  @post.errors
      render :edit
    end
  end 
  def search 
    key = params[:post][:keyword]
    @posts = Post.paginate(page: params[:page], per_page: 10).where("title LIKE ? OR description LIKE ?", "%#{key}%", "%#{key}%")
    render :index
  end

  def import
  end
  def upload 
    if params[:post].present?
      file_name = params[:post][:file]
      if file_name.content_type != "text/csv"
        flash[:error] = "Please Choose CSV format" 
        redirect_to "/import"
        return 
      end
      csv_file = File.open(file_name)

      # Parse the CSV file into an array of hashes
      data = CSV.parse(csv_file, headers: true).map(&:to_h)
  
      if data.size != 3
        flash[:error] = "Post Upload csv must have 3 columns."
        redirect_to "/import"
        return
      end
      # Set the create_user_id and updated_user_id fields for each record
      data.each do |record|
        record["create_user_id"] = session[:user_id]
        record["updated_user_id"] = session[:user_id]
        
      end
  
      # Import the data into the posts table
      begin
        Post.import(data, validate: false)
        flash[:notice] = ["Posts Imported!"]
        redirect_to "/posts"
        return
      rescue ActiveRecord::Import::Error => e
        flash[:alert] = ["Failed to import posts"]
        redirect_to "/import"
        return
      end
    else
      flash[:error] = "Please Choose a file"
      redirect_to "/import"
      return
    end
      
  end
  def export
    posts = Post.all

    if posts.is_a?(ActiveRecord::Relation)

      csv_string = posts.to_csv
      send_data csv_string, filename: "posts.csv", type: "text/csv"
    else
      puts "Error: The posts collection is not an instance of the ActiveRecord::Relation class"
    end
  end
  def destroy
    puts "delete method"
    @post = Post.find(params[:id])
    @post.destroy
    flash[:post_deleted] = ['Post Successfully Deleted.']
    redirect_to "/posts"
    # redirect_to posts_path, notice: "Post was successfully deleted."
  end

    private
    def post_params
      params.require(:post).permit(:title, :description)
    end
    private
    def confirm_post_params
      params.require(:confirm).permit(:title, :description)
    end
    private
    def edit_post_params
      params.require(:post).permit( :id, :title, :description, :status)
    end
    private
    def check_permissions
      unless session[:user_id]
        redirect_to "/login"
      end
    end
end
