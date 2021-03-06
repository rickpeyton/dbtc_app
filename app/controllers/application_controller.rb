class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?


  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    access_denied unless logged_in?
  end

  def require_same_user(user)
    access_denied unless logged_in? && (user == current_user)
  end

  def access_denied
    flash[:danger] = "You must be logged in to do that."
    redirect_to login_path
  end

  def set_time_zone
    if logged_in?
      Time.use_zone(current_user.time_zone) { yield }
    else
      yield
    end
  end
end
