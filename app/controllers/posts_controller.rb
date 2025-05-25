class PostsController < ApplicationController
  before_action :authorize_request   
  def create
    @post = @current_user.posts.build(post_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @post = Post.find_by(id: params[:id])
    if @post.nil?
      return render json: { error: "Post not found" }, status: :not_found
    end

    if @post.user_id != @current_user.id
      return render json: { error: "You are not the owner of this post" }, status: :forbidden
    end

    if @post.update(post_params)
      render json: @post, status: :ok
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end
   def destroy
    @post = Post.find_by(id: params[:id])
    if @post.nil?
      return render json: { error: "Post not found" }, status: :not_found
    end

    if @post.user_id != @current_user.id
      return render json: { error: "You are not the owner of this post" }, status: :forbidden
    end

    if @post.destroy
      render json: {message: "deleted"}, status: :ok
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end
  private
  def post_params
    params.require(:post).permit(:title, :body, tag_ids: [])
  end

    

end
