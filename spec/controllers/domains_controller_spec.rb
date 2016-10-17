require 'spec_helper'

describe DomainsController do
  before(:all) do
    2.times { create(:domain) }
  end
  render_views

  context 'as user' do
    login_user Domain

    it 'index action should render index template' do
      get :index
      response.should render_template(:index)
    end

    it 'edit action should render edit template' do
      get :edit, id: Domain.first
      response.should render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      Domain.any_instance.stubs(:valid?).returns(false)
      put :update, id: Domain.first, domain: attributes_for(:domain)
      response.should render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      Domain.any_instance.stubs(:valid?).returns(true)
      put :update, id: Domain.first, domain: attributes_for(:domain)
      response.should redirect_to(domains_path)
    end
  end

  context 'as admin user' do
    login_admin_user

    it 'new action should render new template' do
      get :new
      response.should render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      Domain.any_instance.stubs(:valid?).returns(false)
      post :create, domain: attributes_for(:domain)
      response.should render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      Domain.any_instance.stubs(:valid?).returns(true)
      post :create, domain: attributes_for(:domain)
      response.should redirect_to(domains_path)
    end

    it 'destroy action should destroy model and redirect to index action' do
      domain = Domain.first
      delete :destroy, id: domain
      response.should redirect_to(domains_path)
      Domain.exists?(domain.id).should be_falsey
    end
  end
end
