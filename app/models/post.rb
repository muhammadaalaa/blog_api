class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :tags

  validates :title, :body, presence: true


  after_create_commit { PostDeletionJob.set(wait: 24.hours).perform_later(id) }
end
