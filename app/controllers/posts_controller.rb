class PostsController < ApplicationController
  def index
    # @posts = Post.all
    @posts = Post.all.paginate(page: params[:page], per_page: 10)
  end
  def new
    @post = Post.new
  end
  def create
  puts post_params
    @post = Post.new(post_params)
    @post.status = 1
    @post.create_user_id = session[:user_id]
    @post.updated_user_id = session[:user_id]
    if @post.save
      flash[:post_created] = ['Post Successfully Created.']
      redirect_to "/posts"
    else
      flash.now[:error] = @post.errors.full_messages
      render :new
      # puts @post.errors.full_messages
    end
  end 
  def show 
    @post = Post.find(params[:id])
  end
  def edit
    @post = Post.find(params[:id])
  end
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: "Post was successfully deleted."
  end

  private
    def post_params
      params.require(:post).permit(:title, :description)
    end
end
