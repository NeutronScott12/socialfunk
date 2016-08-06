class ContentsController < ApplicationController

	before_action :find_topic

	def create
		@content = @topic.contents.build(content_param)
		@content.user_id = current_user.id if current_user
		@content.save

		if @content.save
			redirect_to :back
		else
			redirect_to :back
		end
	end

	def edit
	end

	def update
	end

	def destroy
	end

	private

	def find_topic
		@topic = Topic.find(params[:topic_id])
	end

	def find_content
		@content = @topic.contents.find(params[:id])
	end

	def content_param
		params.require(:content).permit(:comment)
	end

end
