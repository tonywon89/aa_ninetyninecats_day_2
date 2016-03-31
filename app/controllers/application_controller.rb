class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def login_user!
    session[:session_token] = @user.session_token
  end

  def check_owner
    if current_user.cats.where(id: params[:id]).empty?
      flash[:not_owner] = "You are not the owner"
      redirect_to cats_url
    end
  end

  def log_out!
    current_user.reset_session_token!
    session[:session_token] = nil
    @current_user = nil
  end

  def check_not_logged_in
    redirect_to cats_url if current_user
  end
end
