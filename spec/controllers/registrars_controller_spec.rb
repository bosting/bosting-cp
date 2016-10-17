require 'spec_helper'

describe RegistrarsController do
  before(:all) do
    2.times { create(:registrar) }
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
      Registrar.any_instance.stubs(:valid?).returns(false)
      post :create, registrar: attributes_for(:registrar)
      response.should render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      Registrar.any_instance.stubs(:valid?).returns(true)
      post :create, registrar: attributes_for(:registrar)
      response.should redirect_to(registrars_path)
    end

    it 'edit action should render edit template' do
      get :edit, id: Registrar.first
      response.should render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      Registrar.any_instance.stubs(:valid?).returns(false)
      put :update, id: Registrar.first, registrar: attributes_for(:registrar)
      response.should render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      Registrar.any_instance.stubs(:valid?).returns(true)
      put :update, id: Registrar.first, registrar: attributes_for(:registrar)
      response.should redirect_to(registrars_path)
    end

    it 'destroy action should destroy model and redirect to index action' do
      registrar = Registrar.first
      delete :destroy, id: registrar
      response.should redirect_to(registrars_path)
      Registrar.exists?(registrar.id).should be_falsey
    end
  end
end
