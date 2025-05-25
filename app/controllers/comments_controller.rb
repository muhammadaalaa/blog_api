class CommentsController < ApplicationController
    before_action :authorize_request   
  
  def create
    @post = Post.find_by(id: params[:post_id])
    
    unless @post
      return render json: { error: "Post not found" }, status: :not_found
    end

    @comment = @current_user.comments.build(comment_params) # ← fixed typo: `comment_paramss` → `comment_params`
    @comment.post = @post

    if @comment.save
      render json: @comment, status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @comment = Comment.find_by(id: params[:id])
    
    if @comment.nil?
      return render json: { error: "Comment not found" }, status: :not_found
    end

    if @comment.user_id != @current_user.id
      return render json: { error: "You are not authorized to edit this comment" }, status: :forbidden
    end

    if @comment.update(comment_params)
      render json: @comment, status: :ok
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def destroy 
    @comment = Comment.find_by(id: params[:id])
    if @comment.nil?
      return render json:{error:"comment not found"},status: :not_found
    end
    if @comment.user_id != @current_user.id
      return render json: {errors: "You are not authorized to delete this comment" },status: :forbidden
    end
    @deleted_comment = @comment.destroy
    if @deleted_comment
      render json:{ message: "Comment deleted successfully" }, status: :ok
    else 
      render json:{ errors: @comment.errors.full_messages }, status: :forbidden
    end
  end 
   private
    def comment_params
      params.require(:comment).permit(:body)
    end
end
  