require 'spec_helper'

describe SystemUserShellsController do
  before(:all) do
    2.times { create(:system_user_shell) }
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
      SystemUserShell.any_instance.stubs(:valid?).returns(false)
      post :create, system_user_shell: attributes_for(:system_user_shell)
      response.should render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      SystemUserShell.any_instance.stubs(:valid?).returns(true)
      post :create, system_user_shell: attributes_for(:system_user_shell)
      response.should redirect_to(system_user_shells_path)
    end

    it 'edit action should render edit template' do
      get :edit, id: SystemUserShell.first
      response.should render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      SystemUserShell.any_instance.stubs(:valid?).returns(false)
      put :update, id: SystemUserShell.first, system_user_shell: attributes_for(:system_user_shell)
      response.should render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      SystemUserShell.any_instance.stubs(:valid?).returns(true)
      put :update, id: SystemUserShell.first, system_user_shell: attributes_for(:system_user_shell)
      response.should redirect_to(system_user_shells_path)
    end

    it 'destroy action should destroy model and redirect to index action' do
      system_user_shell = SystemUserShell.first
      delete :destroy, id: system_user_shell
      response.should redirect_to(system_user_shells_path)
      SystemUserShell.exists?(system_user_shell.id).should be_falsey
    end
  end
end
