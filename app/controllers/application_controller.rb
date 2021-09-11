class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :reset_session_expiration

  before_action :session_expires

  def session_expires
    if session[:user_id] && session[:expires_at]
      validate_session_expiration
    elsif session[:user_id] && session[:expires_at].nil?
      reset_session_expiration
    end
  end

  def validate_session_expiration
    if (session[:expires_at].to_time - Time.now).to_i <= 0
      session[:user_id] = nil
      reset_session
      flash[:alert] = 'Session expired, please re-enter your credentials.'
      redirect_to login_path
    else
      reset_session_expiration
    end
  end

  def reset_session_expiration
    session[:expires_at] = 10.minutes.from_now
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def error_message(errors)
    errors.full_messages.join(', ')
  end
end
