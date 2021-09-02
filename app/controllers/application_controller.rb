class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  before_action :session_expires, :except => [:login, :logout]

  def session_expires
    if !session[:expires_at].nil?
      time_left = (session[:expires_at].to_time - Time.now).to_i
      if time_left <= 0
        reset_session
        flash[:error] = 'Session Expired.'
        redirect_to login_path
      end
    end
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def error_message(errors)
    errors.full_messages.join(', ')
  end
end
