class Micropost < ApplicationRecord
	
	has_many :comments, dependent: :destroy
	belongs_to :user

	validates :user_id, :presence => true
	validates :content, :presence => true, :length => {:maximum => 140}

	WillPaginate.per_page = 30

	default_scope -> {order(created_at: :desc)}
end
