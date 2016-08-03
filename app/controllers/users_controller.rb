class UsersController < ApplicationController

	before_action :find_user, only: [:show, :index, :edit, :following, :followers]
	before_action :logged_in_user, only: [:edit, :update, :destroy]
	before_action :correct_user, only: [:edit, :update]
	before_action :already_logged_in?, only: [:create, :new]

	def index 
		@user = User.search(params[:search])
		if logged_in?
			@micropost = current_user.microposts.build if logged_in?
			@feed_items = current_user.feed
		end
	end

	def following
		@title = "Following"
		@users = @user.following.paginate(:page => params[:page], :per_page => 30)
		render 'show_follow'
	end	

	def followers 
		@title = "Followers"
		@users = @user.followers.paginate(:page => params[:page], :per_page => 30)
		render 'show_follow'
	end

	def search
		@user = User.search(params[:search]) do 
			@user 
		end
	end

	def new
		@user = User.new
	end

	def show
		@micropost = current_user.microposts.build if logged_in?
		@feed_items = current_user.feed.paginate(:page => params[:page], :per_page => 20)
		@microposts = @user.microposts.paginate(:page => params[:page], :per_page => 20)
		@users = @user.following.paginate(:page => params[:page], :per_page => 20)
		@Micropost = Micropost.find_by(params[:slug])
	end

	def create
		@user = User.new(user_params)
		respond_to do |format| 
			if @user.save
				@user.send_activation_email
				format.html {redirect_to root_url}
				format.json {render root_url, status: :created}
				flash[:success] = "Please Check Your Email To Activate Your Account"
			else
				format.html {render :new}
				format.json {render :new, @user.errors, status: :unprocessable_entity}
				flash[:warning] = "Unsuccessful"
			end
		end
	end

	def edit
	end

	def update
		respond_to do |format|
			if @user.update(user_params)
				format.html {redirect_to @user}
				format.json {redirect_to @user, status: :ok}
				flash[:success] = "Updated Successfully"
			else
				format.html {render '/edit_member'} 
				format.json {render '/edit_member', status: :unprocessable_entity}
				flash[:warning] = "Unsuccessful"
			end
		end
	end

	def destroy
		@user.destroy
		flash[:success] = "Account Deleted"
		respond_to do |format|
			format.html {redirect_to root_path}
			format.json {render root_path, status: :no_content}
		end
	end

	private 

	def user_params
		params.require(:user).permit(:username, :email, :password, :password_confirmation)
	end

	def find_user 
		@user = User.find_by_slug(params[:id].split("/").last)
	end

	def correct_user 
		@user = User.find_by_slug(params[:id])
		redirect_to (root_url) unless current_user?(@user)
	end
end
