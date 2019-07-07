require 'spec_helper'

describe SystemUserShellsController do
  let!(:system_user_shell) { create(:system_user_shell) }

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
      SystemUserShell.any_instance.stubs(:valid?).returns(false)
      post :create, system_user_shell: attributes_for(:system_user_shell)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      SystemUserShell.any_instance.stubs(:valid?).returns(true)
      post :create, system_user_shell: attributes_for(:system_user_shell)
      expect(response).to redirect_to(system_user_shells_url)
    end

    it 'edit action should render edit template' do
      get :edit, id: system_user_shell
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      SystemUserShell.any_instance.stubs(:valid?).returns(false)
      put :update, id: system_user_shell, system_user_shell: attributes_for(:system_user_shell)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      SystemUserShell.any_instance.stubs(:valid?).returns(true)
      put :update, id: system_user_shell, system_user_shell: attributes_for(:system_user_shell)
      expect(response).to redirect_to(system_user_shells_url)
    end

    it 'destroy action should destroy model and redirect to index action' do
      delete :destroy, id: system_user_shell
      expect(response).to redirect_to(system_user_shells_url)
      SystemUserShell.exists?(system_user_shell.id).should be_falsey
    end
  end
end
