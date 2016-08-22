require 'spec_helper'

describe EditUsersController do
  before(:all) do
    2.times { create(:edit_user) }
  end
  render_views

  context 'as admin user' do
    login_admin_user

    it "index action should render index template" do
      get :index
      response.should render_template(:index)
    end

    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end

    it "create action should render new template when model is invalid" do
      EditUser.any_instance.stubs(:valid?).returns(false)
      post :create, edit_user: attributes_for(:edit_user)
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      EditUser.any_instance.stubs(:valid?).returns(true)
      post :create, edit_user: attributes_for(:edit_user)
      response.should redirect_to(edit_users_path)
    end

    it "edit action should render edit template" do
      get :edit, id: EditUser.first
      response.should render_template(:edit)
    end

    it "update action should render edit template when model is invalid" do
      EditUser.any_instance.stubs(:valid?).returns(false)
      put :update, id: EditUser.first, edit_user: attributes_for(:edit_user)
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      EditUser.any_instance.stubs(:valid?).returns(true)
      put :update, id: EditUser.first, edit_user: attributes_for(:edit_user)
      response.should redirect_to(edit_users_path)
    end

    it "destroy action should destroy model and redirect to index action" do
      edit_user = EditUser.first
      delete :destroy, id: edit_user
      response.should redirect_to(edit_users_path)
      EditUser.exists?(edit_user.id).should be_falsey
    end
  end
end
