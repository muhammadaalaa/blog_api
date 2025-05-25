class PostDeletionJob < ApplicationJob
    queue_as :default
  
    def perform(post_id)
      Rails.logger.info "Deleting post with ID #{post_id}"
      post = Post.find_by(id: post_id)
      post&.destroy
    end
  end