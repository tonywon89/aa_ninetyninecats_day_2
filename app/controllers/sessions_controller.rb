class SessionsController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    user_name = session_params[:user_name]
    password = session_params[:password]

    @user = User.find_by_credentials(user_name, password)

    if @user
      @user.reset_session_token!
      session[:session_token] = @user.session_token
      redirect_to cats_url
    else
      flash.now[:error] = "Incorrect username or password"
      render :new
    end
  end

  def destroy
  end

  private

  def session_params
    params.require(:session).permit(:user_name, :password)
  end
end
