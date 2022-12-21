class PostsController < ApplicationController
  before_action :check_permissions, only: [:index, :new, :confirm, :edit, :editConfirm, :update, :delete]
  def index
    # @posts = Post.all
    @posts = Post.paginate(page: params[:page], per_page: 10)
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
  #   #flash.now[:error] = @confirm_post.errors.full_messages
  #   #flash[:error] = @confirm_post.errors.full_messages.join(", ")
    @confirm_post =  @confirm_post.errors
    # render :new
    render '/posts/new'
  #   # puts @confirm_post.errors.full_messages
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
    puts "this is comfirm status #{@post.status}"
  #  render "editConfirm"
    # render :new unless @post.valid?
  end
  def search 
    key = search_post_params
    # @posts = Post.where("title LIKE ? OR description LIKE ?", "%#{key}%", "%#{key}%")
    @posts = Post.find_by(email: email, description: key)
    puts @posts
    render :index
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
      params.require(:post).permit(:id, :title, :description, :status)
    end
    private
    def search_post_params
      params.require(:post).permit(:keyword)
    end
    private
    def check_permissions
      unless session[:user_id]
        redirect_to "/login"
      end
    end
end
