require "rails_helper"

describe SessionsController do
  describe "GET #new" do
    it "redirects to the first user chain if logged in" do
      alice = Fabricate(:user)
      chain1 = Fabricate(:chain, user: alice)
      Fabricate(:chain, user: alice)
      session[:user_id] = alice.id
      get :new
      expect(response).to redirect_to user_chain_path(alice, chain1)
    end
  end

  describe "POST #create" do
    context "with valid input" do
      let(:alice) { Fabricate(:user) }

      it "redirects to the users first chain" do
        chain1 = Fabricate(:chain, user: alice)
        post :create, email: alice.email, password: "password"
        expect(response).to redirect_to user_chain_path(alice, chain1.id)
      end

      it "sets the session" do
        Fabricate(:chain, user: alice)
        post :create, email: alice.email, password: "password"
        expect(session[:user_id]).to eq(User.first.id)
      end

      it "sets the success message" do
        Fabricate(:chain, user: alice)
        post :create, email: alice.email, password: "password"
        expect(flash[:success]).not_to be_empty
      end
    end

    context "with invalid input" do
      it "redirects to the login path" do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: ""
        expect(response).to redirect_to login_path
      end

      it "sets the session to nil" do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: ""
        expect(session[:user_id]).to be_nil
      end

      it "sets the error message" do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: ""
        expect(flash[:danger]).not_to be_empty
      end
    end
  end

  describe "GET #destroy" do
    it "redirects to the login page" do
      get :destroy
      expect(response).to redirect_to login_path
    end

    it "sets the session to nil" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      get :destroy
      expect(session[:user_id]).to eq(nil)
    end

    it "sets the success message" do
      get :destroy
      expect(flash[:success]).not_to be_empty
    end
  end
end
