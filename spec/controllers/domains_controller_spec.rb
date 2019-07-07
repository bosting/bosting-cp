require 'spec_helper'

describe DomainsController do
  let!(:domain) { create(:domain) }

  render_views

  context 'as user' do
    login_user Domain

    it 'index action should render index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'edit action should render edit template' do
      get :edit, id: domain
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      Domain.any_instance.stubs(:valid?).returns(false)
      put :update, id: domain, domain: attributes_for(:domain)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      Domain.any_instance.stubs(:valid?).returns(true)
      put :update, id: domain, domain: attributes_for(:domain)
      expect(response).to redirect_to(domains_url)
    end
  end

  context 'as admin user' do
    login_admin_user

    it 'new action should render new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      Domain.any_instance.stubs(:valid?).returns(false)
      post :create, domain: attributes_for(:domain)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      Domain.any_instance.stubs(:valid?).returns(true)
      post :create, domain: attributes_for(:domain)
      expect(response).to redirect_to(domains_url)
    end

    it 'destroy action should destroy model and redirect to index action' do
      delete :destroy, id: domain
      expect(response).to redirect_to(domains_url)
      Domain.exists?(domain.id).should be_falsey
    end
  end
end
