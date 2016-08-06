class Forum < ApplicationRecord

	belongs_to :user
	has_many :topics

	validates :title, presence: true, uniqueness: true
	validates :user_id, presence: true, uniqueness: true
	validates :category_id, presence: true, uniqueness: true

end
