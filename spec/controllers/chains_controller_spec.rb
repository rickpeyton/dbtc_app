require "rails_helper"

describe ChainsController do
  describe "GET #show" do
    let(:alice) { Fabricate(:user) }
    let(:chain1) { Fabricate(:chain, user: alice) }

    context "with a valid user session" do
      before do
        session[:user_id] = alice.id
        get :show, user_id: alice.id, id: chain1.id
      end

      it "sets the user variable" do
        expect(assigns(:user)).to eq(alice)
      end

      it "sets the chain variable" do
        expect(assigns(:chain)).to eq(alice.chains.first)
      end

    end
    context "with a user session who is not the user" do
      it "redirects to the logout path" do
        session[:user_id] = Fabricate(:user).id
        get :show, user_id: session[:user_id], id: chain1.id
        expect(response).to redirect_to login_path
      end

    end
    context "with no user session" do
      it "redirects to the login path"
    end
  end

  describe "GET #new" do
    let(:alice) { Fabricate(:user) }

    context "with a valid user session" do
      before do
        session[:user_id] = alice.id
        get :new, user_id: alice.id
      end

      it "sets the user" do
        expect(assigns(:user)).to eq(alice)
      end

      it "sets the new chain" do
        expect(assigns(:chain)).to be_an_instance_of(Chain)
      end
    end

    context "with an invalid user session" do
      it "redirects to the login screen" do
        get :new, user_id: alice.id
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "POST #create" do
    let(:alice) { Fabricate(:user) }
    let(:chain) { Fabricate.attributes_for(:chain) }

    context "with a valid user session" do
      before do
        session[:user_id] = alice.id
        post :create, chain: chain, user_id: alice.id
      end

      it "saves the chain" do
        expect(User.first.chains.count).to eq(1)
      end

      it "sets the success message" do
        expect(flash[:success]).not_to be_empty
      end

      it "redirects to the chain page" do
        expect(response).to redirect_to user_chain_path(alice, alice.chains.first)
      end
    end

    context "with an invalid user session" do
      it "redirects to the login screen" do
        post :create, chain: chain, user_id: alice.id
        expect(response).to redirect_to login_path
      end
    end
  end
end
