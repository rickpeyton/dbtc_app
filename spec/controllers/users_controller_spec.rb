require "rails_helper"

describe UsersController do
  describe "GET #new" do
    it "sets @user variable if a user is not logged in" do
      get :new
      expect(assigns(:user)).to be_an_instance_of(User)
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
end
