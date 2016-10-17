require 'spec_helper'

describe SystemGroupsController do
  before(:all) do
    2.times { create(:system_group) }
  end
  render_views

  context 'as admin user' do
    login_admin_user

    it 'index action should render index template' do
      get :index
      response.should render_template(:index)
    end

    it 'new action should render new template' do
      get :new
      response.should render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      SystemGroup.any_instance.stubs(:valid?).returns(false)
      post :create, system_group: attributes_for(:system_group)
      response.should render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      SystemGroup.any_instance.stubs(:valid?).returns(true)
      post :create, system_group: attributes_for(:system_group)
      response.should redirect_to(system_groups_path)
    end

    it 'edit action should render edit template' do
      get :edit, id: SystemGroup.first
      response.should render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      SystemGroup.any_instance.stubs(:valid?).returns(false)
      put :update, id: SystemGroup.first, system_group: attributes_for(:system_group)
      response.should render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      SystemGroup.any_instance.stubs(:valid?).returns(true)
      put :update, id: SystemGroup.first, system_group: attributes_for(:system_group)
      response.should redirect_to(system_groups_path)
    end

    it 'destroy action should destroy model and redirect to index action' do
      system_group = SystemGroup.first
      delete :destroy, id: system_group
      response.should redirect_to(system_groups_path)
      SystemGroup.exists?(system_group.id).should be_falsey
    end
  end
end
