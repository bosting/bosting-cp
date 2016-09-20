require 'spec_helper'

describe EmailDomainsController do
  before(:all) do
    2.times { create(:email_domain) }
  end
  render_views

  context 'as admin user' do
    login_admin_user

    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end

    it "index action should render index template" do
      get :index
      response.should render_template(:index)
    end

    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end

    it "create action should render new template when model is invalid" do
      EmailDomain.any_instance.stubs(:valid?).returns(false)
      post :create, email_domain: params_for(:email_domain)
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      EmailDomain.any_instance.stubs(:valid?).returns(true)
      post :create, email_domain: params_for(:email_domain)
      response.should redirect_to(email_domains_path)
    end

    it "edit action should render edit template" do
      get :edit, id: EmailDomain.first
      response.should render_template(:edit)
    end

    it "update action should render edit template when model is invalid" do
      EmailDomain.any_instance.stubs(:valid?).returns(false)
      put :update, id: EmailDomain.first, email_domain: params_for(:email_domain)
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      EmailDomain.any_instance.stubs(:valid?).returns(true)
      put :update, id: EmailDomain.first, email_domain: params_for(:email_domain)
      response.should redirect_to(email_domains_path)
    end

    it "destroy action should destroy model and redirect to index action" do
      email_domain = EmailDomain.first
      delete :destroy, id: email_domain
      response.should redirect_to(email_domains_path)
      EmailDomain.exists?(email_domain.id).should be false
    end
  end
end
