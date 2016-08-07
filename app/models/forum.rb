class Forum < ApplicationRecord

	belongs_to :user
	has_many :topics

	validates :title, presence: true
	validates :user_id, presence: true
	validates :category_id, presence: true

	def category(arg)
		Forum.where(category_id: arg.to_i)
	end

end
