class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  has_many :post_tags
  has_many :tags, through: :post_tags

  validates :title, :body, presence: true
end
