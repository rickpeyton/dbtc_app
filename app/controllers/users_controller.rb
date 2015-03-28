class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "You have successfully joined DBTC"
      session[:user_id] = @user.id
      redirect_to new_user_chain_path(@user)
    else
      flash[:danger] = "Please fix the errors below"
      render :new
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password)
    end
end
