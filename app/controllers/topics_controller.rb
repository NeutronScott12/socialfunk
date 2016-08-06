class TopicsController < ApplicationController

	before_action :find_topic, except: [:create]
	before_action :find_forum, except: [:show]

	def show
	end

	def create
		@topic = @forum.topics.build(topics_param)
		@topic.user_id = current_user.id
		@topic.save

		if @topic.save
			redirect_to :back
		else
			render :back
		end
	end

	def edit
	end

	def update
	end

	def destroy
	end

	private

	def topics_param 
		params.require(:topic).permit(:title, :description)
	end

	def find_forum
		@forum = Forum.find(params[:forum_id])
	end

	def find_topic
		@topic = Topic.find(params[:id])
	end

end
