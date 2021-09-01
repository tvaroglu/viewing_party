class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def error_message(errors)
    errors.full_messages.join(', ')
  end
end
