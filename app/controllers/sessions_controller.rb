class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to user_chain_path(current_user, current_user.chains.first)
    end
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:success] = "You logged in successfully"
      if @user.chains.count > 0
        redirect_to user_chain_path(@user, @user.chains.first)
      else
        redirect_to new_user_chain_path(@user)
      end
    else
      flash[:danger] = "Your login attempt failed"
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have successfully logged out"
    redirect_to login_path
  end
end
