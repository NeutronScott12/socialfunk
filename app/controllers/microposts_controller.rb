class MicropostsController < ApplicationController

	before_action :logged_in_user, only: [:create, :destroy]

	def create 
		@micropost = current_user.mircoposts.build(micropost_params)
		respond_to do |format|
			if @micropost.save
				format.html {redirect_to root_url}
				format.json {render root_url, status: :created}
				flash[:success] = "Post Uploaded"
			else
				format.html {render 'static_pages/home'}
				format.json {render 'static_pages/home', status: :unprocessable_entity}
				@feed_items = []
			end	
		end
	end

	def destroy
	end

	private 

	def micropost_params
		params.require(:micropost).permit(:content)
	end

end
