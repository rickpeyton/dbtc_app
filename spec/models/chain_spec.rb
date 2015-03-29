require "rails_helper"

describe Chain do
  it { should belong_to(:user) }
  it { should have_many(:links) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:user_id) }

  describe "#current_chain" do
    it "returns the consecutive days a chain has links" do
      alice = Fabricate(:user)
      alice_chain = Fabricate(:chain, user: alice)
      Fabricate(:link, link_day: Time.now.utc.midnight - 1.day, chain: alice_chain)
      Fabricate(:link, link_day: Time.now.utc.midnight - 2.days, chain: alice_chain)
      Fabricate(:link, link_day: Time.now.utc.midnight - 4.days, chain: alice_chain)
      expect(alice_chain.current_chain).to eq(2)
    end

    it "compares to the longest chain and updates if current chain is longer" do
      alice = Fabricate(:user)
      alice_chain = Fabricate(:chain, user: alice, longest_chain: 2)
      Fabricate(:link, link_day: Time.now.utc.midnight - 1.day, chain: alice_chain)
      Fabricate(:link, link_day: Time.now.utc.midnight - 2.days, chain: alice_chain)
      Fabricate(:link, link_day: Time.now.utc.midnight - 3.days, chain: alice_chain)
      Fabricate(:link, link_day: Time.now.utc.midnight - 5.days, chain: alice_chain)
      alice_chain.current_chain
      expect(alice_chain.longest_chain).to eq(3)
    end
  end

end

