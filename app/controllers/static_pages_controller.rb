class StaticPagesController < ApplicationController

	def home
		if logged_in?
			@micropost = current_user.microposts.build if logged_in?
			@feed_items = current_user.feed
		end
	end

end
