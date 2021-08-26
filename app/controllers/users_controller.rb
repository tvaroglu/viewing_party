class UsersController < ApplicationController
  def login; end

  def new
    @user = User.new
  end

  def create
    user = user_params
    user[:email] = user[:email].downcase
    new_user = User.create(user)
    if new_user.save
      redirect_to dashboard_path(new_user.id)
      flash[:alert] = "Registration complete! Welcome, #{new_user.email}!"
    else
      redirect_to registration_path
      flash[:alert] = "Oops, couldn't create your account. Please make sure you are using a valid email and password."
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def authenticate; end

  private
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
