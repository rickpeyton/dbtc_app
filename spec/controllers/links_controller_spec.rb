require "rails_helper"

describe LinksController do

  describe "POST #create" do
    let(:alice) { Fabricate(:user) }
    before do
      session[:user_id] = alice.id
    end

    it "redirects to the chain the request came from" do
      chain1 = Fabricate(:chain, user: alice)
      time1 = Time.now.strftime("%Y/%m/%d")
      post :create, chain: chain1.id, user: alice.id, time: time1
      expect(response).to redirect_to user_chain_path(alice, chain1)
    end

    it "creates a new link for the specified day" do
      chain1 = Fabricate(:chain, user: alice)
      time1 = Time.now.strftime("%Y/%m/%d")
      post :create, chain: chain1.id, time: time1, user: alice.id
      expect(Link.all.count).to eq(1)
    end

    it "creates a new link associated with the specified chain" do
      chain1 = Fabricate(:chain, user: alice)
      time1 = Time.now.strftime("%Y/%m/%d")
      post :create, chain: chain1.id, time: time1, user: alice.id
      expect(Link.first.chain).to eq(chain1)
    end

    it "redirects to the login path if not logged in" do
      chain1 = Fabricate(:chain, user: alice)
      time1 = Time.now.strftime("%Y/%m/%d")
      session[:user_id] = nil
      post :create, chain: chain1.id, time: time1, user: alice.id
      expect(response).to redirect_to login_path
    end

    it "redirects to the login path if creator is not owner" do
      chain1 = Fabricate(:chain, user: alice)
      time1 = Time.now.strftime("%Y/%m/%d")
      session[:user_id] = Fabricate(:user).id
      post :create, chain: chain1.id, time: time1, user: alice.id
      expect(alice.chains.first.links.count).to eq(0)
    end

    it "does not create if link_day is > 7 days ago" do
      chain1 = Fabricate(:chain, user: alice)
      time1 = (Time.now - 10.days).strftime("%Y/%m/%d")
      post :create, chain: chain1.id, time: time1, user: alice.id
      expect(alice.chains.first.links.count).to eq(0)
    end
  end

  describe "DELETE #destroy" do
    let(:alice) { Fabricate(:user) }
    before do
      session[:user_id] = alice.id
    end

    it "redirects to the chain the request came from" do
      chain = Fabricate(:chain, user: alice)
      link = Fabricate(:link, chain: chain)
      delete :destroy, id: link
      expect(response).to redirect_to user_chain_path(alice, chain)
    end

    it "deletes the link" do
      chain = Fabricate(:chain, user: alice)
      link = Fabricate(:link, chain: chain)
      expect(Link.all.count).to eq(1)
      delete :destroy, id: link
      expect(Link.all.count).to eq(0)
    end

    it "requires a logged in user" do
      chain = Fabricate(:chain, user: alice)
      link = Fabricate(:link, chain: chain)
      session[:user_id] = nil
      delete :destroy, id: link
      expect(Link.all.count).to eq(1)
    end

    it "requires that the user be the logged in user" do
      chain = Fabricate(:chain, user: alice)
      link = Fabricate(:link, chain: chain)
      session[:user_id] = Fabricate(:user).id
      delete :destroy, id: link
      expect(Link.all.count).to eq(1)
    end
  end
end
