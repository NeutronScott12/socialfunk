class Topic < ApplicationRecord

	belongs_to :user
	belongs_to :forum
	has_many :contents

end
