require 'spec_helper'

describe EmailDomainsController do
  let!(:email_domain) { create(:email_domain) }

  render_views

  context 'as admin user' do
    login_admin_user

    it 'new action should render new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'index action should render index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'new action should render new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      EmailDomain.any_instance.stubs(:valid?).returns(false)
      post :create, email_domain: params_for(:email_domain)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      EmailDomain.any_instance.stubs(:valid?).returns(true)
      post :create, email_domain: params_for(:email_domain)
      expect(response).to redirect_to(email_domains_url)
    end

    it 'edit action should render edit template' do
      get :edit, id: email_domain
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      EmailDomain.any_instance.stubs(:valid?).returns(false)
      put :update, id: email_domain, email_domain: params_for(:email_domain)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      EmailDomain.any_instance.stubs(:valid?).returns(true)
      put :update, id: email_domain, email_domain: params_for(:email_domain)
      expect(response).to redirect_to(email_domains_url)
    end

    it 'destroy action should destroy model and redirect to index action' do
      delete :destroy, id: email_domain
      expect(response).to redirect_to(email_domains_url)
      EmailDomain.exists?(email_domain.id).should be false
    end
  end
end
