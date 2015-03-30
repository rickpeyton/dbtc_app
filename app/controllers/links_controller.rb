class LinksController < ApplicationController
  def create
    @user = User.find(params[:user])
    @chain = @user.chains.find(params[:chain])
    Link.create(link_day: params[:time], chain: @chain)
    redirect_to user_chain_path(@user, @chain)
  end

  def destroy
    @link = Link.find(params[:id])
    @chain = @link.chain
    @user = @chain.user
    recalculate = true if @chain.current_chain == @chain.longest_chain
    @link.destroy
    @chain.recalculate_longest_chain if recalculate
    redirect_to user_chain_path(@user, @chain)
  end
end
