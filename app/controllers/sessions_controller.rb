class SessionsController < ApplicationController
  def new; end

  def create
    found_user = User.find_by(email: params[:email].downcase)
    if !found_user.nil? && found_user.authenticate(params[:password])
      session[:user_id] = found_user.id
      reset_session_expiration
      flash[:alert] = "Welcome, #{found_user.email}!"
      redirect_to dashboard_path(found_user.id)
    else
      flash[:alert] = 'Invalid credentials, please try again.'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    reset_session
    flash[:alert] = 'You are now logged out, please come back soon!'
    redirect_to root_path
  end
end
