class ForumsController < ApplicationController

	before_action :find_forum, only: [:show, :edit, :update, :destroy]

	def show
	end

	def index
		@forum_gaming = Forum.where(category_id: 1)
		@forum_news = Forum.where(category_id: 2)
		@forum_movies = Forum.where(category_id: 3)
		@forum_general = Forum.where(category_id: 4)
		@forum_politics = Forum.where(category_id: 5)
	end

	def show
		@topic = current_user.topics.build if logged_in?
	end

	def new
		@forum = current_user.forums.build
	end

	def create
		@forum = current_user.forums.build(forums_params)
		respond_to do |format|
			if @forum.save 
				format.html {redirect_to forums_path || root_path}
				format.json {render root_path, status: :created, location: root_path}
			else
				format.html {render :new}
				format.json {render :new, status: :unprocessable_entity}
			end
		end
	end

	def edit
	end

	def update
		respond_to do |format|
			if @forum.update 
				format.html {redirect_to @forum}
				format.json {render @forum, status: :sucessful}
			else
				format.html {render :edit}
				format.json {render :edit, status: :unprocessable_entity}
			end
		end
	end

	def destroy
		@forum.destroy
		respond_to do |format|
			format.html {redirect_to root_path}
			format.json {render root_path, status: :successful}
		end
	end

	private

	def forums_params
		params.require(:forum).permit(:title, :category_id, :user_id)
	end

	def find_forum
		@forum = Forum.find(params[:id])
	end

end
