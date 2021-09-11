class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  before_action :session_expires, :except => [:login, :logout]

  def session_expires
    if !session[:expires_at].nil?
      if (session[:expires_at].to_time - Time.now).to_i <= 0
        session[:user_id] = nil
        reset_session
        flash[:error] = 'Session expired, please re-enter your credentials.'
        redirect_to login_path
      else
        session[:expires_at] = 10.minutes.from_now
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
