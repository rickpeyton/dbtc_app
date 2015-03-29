require "rails_helper"

describe LinksController do

  describe "POST #create" do
    let(:alice) { Fabricate(:user) }

    it "redirects to the chain the request came from" do
      chain1 = Fabricate(:chain, user: alice)
      post :create, chain: chain1.id, user: alice.id
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
  end

  describe "DELETE #destroy" do
    it "redirects to the chain the request came from" do
      alice = Fabricate(:user)
      chain = Fabricate(:chain, user: alice)
      link = Fabricate(:link, chain: chain)
      delete :destroy, id: link
      expect(response).to redirect_to user_chain_path(alice, chain)
    end

    it "deletes the link" do
      alice = Fabricate(:user)
      chain = Fabricate(:chain, user: alice)
      link = Fabricate(:link, chain: chain)
      expect(Link.all.count).to eq(1)
      delete :destroy, id: link
      expect(Link.all.count).to eq(0)
    end
  end
end
