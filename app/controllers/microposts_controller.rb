class MicropostsController < ApplicationController

	before_action :logged_in_user, only: [:create, :destroy, :show]
	before_action :correct_user, only: [:destroy]

	def show
		@micropost = Micropost.find(params[:id])
	end

	def create 
		@micropost = current_user.microposts.build(micropost_params)
		respond_to do |format|
			if @micropost.save
				format.html {redirect_to request.referrer || root_url}
				format.json {render root_url, status: :created}
				format.js
				#flash[:success] = "Post Uploaded"
			else
				format.html {render 'static_pages/home'}
				format.json {render 'static_pages/home', status: :unprocessable_entity}
				@feed_items = []
			end	
		end
	end

	def destroy
		@micropost.destroy
		respond_to do |format|
			format.html {redirect_to request.referrer || root_url}
			format.json {render root_url, status: :ok}
			format.js
			#flash[:success] = "Post Deleted"
		end
	end

	private 

	def micropost_params
		params.require(:micropost).permit(:content)
	end

	def correct_user 
		@micropost = current_user.microposts.find_by(id: params[:id])
		redirect_to root_url if @micropost.nil?
	end

end
