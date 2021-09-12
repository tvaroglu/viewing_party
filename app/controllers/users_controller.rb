class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = user_params
    user[:email] = user[:email].downcase
    new_user = User.create(user)
    if new_user.save
      session[:user_id] = new_user.id
      reset_session_expiration
      new_user.followers << User.find_by(email: 'tom@myspace.com') if !User.find_by(email: 'tom@myspace.com').nil?
      redirect_to dashboard_path(new_user.id)
      flash[:alert] = "New account successfully created for: #{new_user.email}!"
    else
      redirect_to registration_path
      flash[:alert] = 'Invalid credentials, please try again.'
    end
  end

  def dashboard
    @user = current_user
  end

  def search
    found_user = User.find_by(email: params[:email].downcase)
    if !found_user.nil? && !current_user.already_friends_with?(found_user.id)
      current_user.followers << found_user
      flash[:alert] = "#{found_user.email} is now following you!"
    elsif !found_user.nil? && current_user.already_friends_with?(found_user.id)
      flash[:alert] = "#{found_user.email} is already following you!"
    else
      flash[:alert] = "Sorry, unable to find an account for \"#{params[:email]}\""
    end
    redirect_to dashboard_path(current_user.id)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
