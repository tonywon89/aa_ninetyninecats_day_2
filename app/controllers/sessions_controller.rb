class SessionsController < ApplicationController
  before_action :check_logged_in, only: [:new]

  def new
    @user = User.new
    render :new
  end

  def create
    user_name = session_params[:user_name]
    password = session_params[:password]

    @user = User.find_by_credentials(user_name, password)

    if @user
      login_user!
      redirect_to cats_url
    else
      flash.now[:error] = "Incorrect username or password"
      render :new
    end
  end

  def destroy

    if current_user
      current_user.reset_session_token!
      session[:session_token] = nil
      @current_user = nil
      redirect_to new_session_url
    else
      redirect_to :back
    end
  end

  private

  def session_params
    params.require(:session).permit(:user_name, :password)
  end

  def check_logged_in
    redirect_to cats_url if current_user
  end
end
