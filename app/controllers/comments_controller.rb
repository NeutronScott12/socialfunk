class CommentsController < ApplicationController

	before_action :micropost_find, only: [:create, :destroy, :index]
	before_action :comment_find, only: [:destroy]

	def create 
		@comment = @micropost.comments.build(comment_params)
		@comment.user_id = current_user.id if current_user
		@comment.save

		respond_to do |format|
			if @comment.save 
				format.html {redirect_to :back || root_url}
				format.json {render :back, status: :created}
			else
				format.html {render :back}
				format.json {render :back, status: :unprocessable_entity}
			end
		end
	end

	def destroy
		@comment.destroy
		respond_to do |format|
			format.html {redirect_to request_referrer || root_url}
			format.json {render request_referrer, status: :ok}
		end
	end

	private 

	def micropost_find
		@micropost = Micropost.find(params[:micropost_id])
	end

	def comment_find
		@comment = @micropost.comments.find(params[:id])
	end

	def comment_params
		params.require(:comment).permit(:content)
	end	

end
