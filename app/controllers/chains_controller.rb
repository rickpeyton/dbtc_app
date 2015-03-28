class ChainsController < ApplicationController
  before_action :set_user
  before_action do
    require_same_user(@user)
  end

  def show
    @chain = Chain.find(params[:id])
    access_denied if @chain.user != current_user
  end

  def new
    @chain = Chain.new
  end

  def create
    @chain = Chain.new(chain_params)
    @user.chains << @chain
    flash[:success] = "Your chain was created!"
    redirect_to user_chain_path(@user, @chain)
  end

  private

    def set_user
      @user = User.find(params[:user_id])
    end

    def chain_params
      params.require(:chain).permit(:name)
    end
end
