require "rails_helper"

describe UsersController do
  describe "GET #new" do
    it "sets @user variable if a user is not logged in" do
      get :new
      expect(assigns(:user)).to be_an_instance_of(User)
    end

    it "redirects to the users first chain if they are logged in" do
      alice = Fabricate(:user)
      Fabricate(:chain, user: alice)
      session[:user_id] = alice.id
      get :new
      expect(response).to redirect_to user_chain_path(alice, alice.chains.first)
    end
  end

  describe "GET #edit" do
    it "only allows the user to access the profile" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      get :edit, id: alice.id
      expect(response).to redirect_to login_path
    end
  end

  describe "POST #create" do
    context "successfully create a new user" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "creates a new user" do
        expect(User.all.count).to eq(1)
      end

      it "sets the flash to success" do
        expect(flash[:success]).not_to be_empty
      end

      it "sets the user into the session" do
        expect(session[:user_id]).to eq(User.first.id)
      end

      it "redirects to the welcome page" do
        expect(response).to redirect_to new_user_chain_path(User.first.id)
      end
    end

    context "new user with invalid input is not created"
      before do
        post :create, user: {email: "john@doe.com", password: nil}
      end

      it "does not create a new user" do
        expect(User.all.count).to eq(0)
      end

      it "sets the flash to danger" do
        expect(flash[:danger]).not_to be_empty
      end

      it "does not set the user in the session" do
        expect(session[:user_id]).to be_nil
      end

      it "sets the user variable" do
        expect(assigns(:user)).to be_an_instance_of(User)
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end
  end

  describe "PATCH #update" do
    let(:alice) { Fabricate(:user) }

    context "with valid input" do
      before do
        session[:user_id] = alice.id
        patch :update, id: alice.id, user: { email: "alice@inchains.com", password: "passwordzzz", time_zone: "Central Time (US & Canada)" }
      end

      it "redirects to the user edit page" do
        expect(response).to redirect_to edit_user_path(alice)
      end

      it "updates the user" do
        expect(User.first.email).to eq("alice@inchains.com")
      end

      it "sets the success message" do
        expect(flash[:success]).not_to be_empty
      end
    end

    it "only allows the user to update the profile" do
      session[:user_id] = Fabricate(:user).id
      patch :update, id: alice.id, user: { email: "alice@inchains.com", password: "passwordzzz", time_zone: "Central Time (US & Canada)" }
      expect(response).to redirect_to login_path
    end

    context "with invalid data" do
      before do
        session[:user_id] = alice.id
        patch :update, id: alice.id, user: { email: "alice@inchains.com", password: "zzz", time_zone: "Central Time (US & Canada)" }
      end

      it "renders the edit template if there is an error" do
        expect(response).to render_template :edit
      end

      it "sets the danger message if there is an error" do
        expect(flash[:danger]).not_to be_empty
      end
    end

  end
end
