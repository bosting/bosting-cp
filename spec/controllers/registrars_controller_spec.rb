require 'spec_helper'

describe RegistrarsController do
  let!(:registrar) { create(:registrar) }

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
      Registrar.any_instance.stubs(:valid?).returns(false)
      post :create, registrar: attributes_for(:registrar)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      Registrar.any_instance.stubs(:valid?).returns(true)
      post :create, registrar: attributes_for(:registrar)
      expect(response).to redirect_to(registrars_url)
    end

    it 'edit action should render edit template' do
      get :edit, id: registrar
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      Registrar.any_instance.stubs(:valid?).returns(false)
      put :update, id: registrar, registrar: attributes_for(:registrar)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      Registrar.any_instance.stubs(:valid?).returns(true)
      put :update, id: registrar, registrar: attributes_for(:registrar)
      expect(response).to redirect_to(registrars_url)
    end

    it 'destroy action should destroy model and redirect to index action' do
      delete :destroy, id: registrar
      expect(response).to redirect_to(registrars_url)
      Registrar.exists?(registrar.id).should be_falsey
    end
  end
end
