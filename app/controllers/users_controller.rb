class UsersController < ApplicationController
  def login; end

  def new
    @user = User.new
  end

  def create
    user = user_params
    user[:username] = user[:username].downcase
    new_user = User.create(user)

    if user.save
      #if user saves in the db successfully... (happy path)
      flash[:success] = "Registration complete! Welcome, #{new_user.username}!"
      # redirect_to user_dashboard_path??
    else
      #if user fails model validation... (sad path)
      flash[:failure] = "Oops, couldn't create your account. Please make sure you are using a valid email and password and try again."
      render :new
    end
  end

  def authenticate; end


  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
