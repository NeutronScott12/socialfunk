class UsersController < ApplicationController

	before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
	before_action :correct_user, only: [:edit, :update]
	before_action :already_logged_in?, only: [:create, :new]

	def new
		@user = User.new
	end

	def show
		@user = User.find(params[:id])
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
		@user = User.find(params[:id])
	end

	def correct_user 
		@user = User.find(params[:id])
		redirect_to (root_url) unless current_user?(@user)
	end
end