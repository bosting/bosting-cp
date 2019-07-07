require 'spec_helper'

describe SystemGroupsController do
  let!(:system_group) { create(:system_group) }

  render_views

  context 'as admin user' do
    login_admin_user

    it 'index action should render index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'new action should render new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      SystemGroup.any_instance.stubs(:valid?).returns(false)
      post :create, system_group: attributes_for(:system_group)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      SystemGroup.any_instance.stubs(:valid?).returns(true)
      post :create, system_group: attributes_for(:system_group)
      expect(response).to redirect_to(system_groups_url)
    end

    it 'edit action should render edit template' do
      get :edit, id: system_group
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      SystemGroup.any_instance.stubs(:valid?).returns(false)
      put :update, id: system_group, system_group: attributes_for(:system_group)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      SystemGroup.any_instance.stubs(:valid?).returns(true)
      put :update, id: system_group, system_group: attributes_for(:system_group)
      expect(response).to redirect_to(system_groups_url)
    end

    it 'destroy action should destroy model and redirect to index action' do
      delete :destroy, id: system_group
      expect(response).to redirect_to(system_groups_url)
      SystemGroup.exists?(system_group.id).should be_falsey
    end
  end
end
