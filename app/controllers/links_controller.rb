class LinksController < ApplicationController
  before_action :require_user, only: [:create, :destroy]

  def create
    @user = User.find(params[:user])
    @chain = @user.chains.find(params[:chain])
    if @user == current_user && Time.parse(params[:time]).utc.midnight > Time.now.utc.midnight - 8.days
      Link.create(link_day: params[:time], chain: @chain) if @user == current_user
    end
    redirect_to user_chain_path(@user, @chain)
  end

  def destroy
    @link = Link.find(params[:id])
    @chain = @link.chain
    @user = @chain.user
    recalculate = true if @chain.current_chain == @chain.longest_chain
    @link.destroy if @user == current_user
    @chain.recalculate_longest_chain if recalculate
    redirect_to user_chain_path(@user, @chain)
  end
end
