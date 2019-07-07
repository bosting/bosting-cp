require 'spec_helper'

describe EditUsersController do
  let!(:edit_user) { create(:edit_user) }

  render_views

  context 'as admin user' do
    login_admin_user

    it do
      get :index
      expect(response).to render_template(:index)
    end

    it 'new action should render new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      EditUser.any_instance.stubs(:valid?).returns(false)
      post :create, edit_user: attributes_for(:edit_user)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      EditUser.any_instance.stubs(:valid?).returns(true)
      post :create, edit_user: attributes_for(:edit_user)
      expect(response).to redirect_to(edit_users_url)
    end

    it 'edit action should render edit template' do
      get :edit, id: edit_user
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      EditUser.any_instance.stubs(:valid?).returns(false)
      put :update, id: edit_user, edit_user: attributes_for(:edit_user)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      EditUser.any_instance.stubs(:valid?).returns(true)
      put :update, id: edit_user, edit_user: attributes_for(:edit_user)
      expect(response).to redirect_to(edit_users_url)
    end

    it 'destroy action should destroy model and redirect to index action' do
      delete :destroy, id: edit_user
      expect(response).to redirect_to(edit_users_url)
      EditUser.exists?(edit_user.id).should be_falsey
    end
  end
end
