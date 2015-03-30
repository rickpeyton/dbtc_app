class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :require_same_user, only: [:edit, :update]

  def new
    redirect_to user_chain_path(current_user, current_user.chains.first) if logged_in?
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    @user.time_zone = "Central Time (US & Canada)"
    if @user.save
      flash[:success] = "You have successfully joined DBTC"
      session[:user_id] = @user.id
      redirect_to new_user_chain_path(@user)
    else
      flash[:danger] = "Please fix the errors below"
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Your profile has been updated!"
      redirect_to edit_user_path(@user)
    else
      flash[:danger] = "There was an error"
      render :edit
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :time_zone)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def require_same_user
      access_denied unless @user == current_user
    end
end
