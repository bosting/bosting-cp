require 'spec_helper'

describe EmailAliasesController do
  before(:all) do
    @email_domain = create(:email_domain)
    2.times { create(:email_alias, email_domain: @email_domain) }
  end
  render_views

  context 'as user' do
    login_user EmailDomain

    it 'index action should render index template' do
      get :index, email_domain_id: @email_domain.id
      response.should render_template(:index)
    end

    it 'new action should render new template' do
      get :new, email_domain_id: @email_domain.id
      response.should render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      EmailAlias.any_instance.stubs(:valid?).returns(false)
      post :create, email_domain_id: @email_domain.id, email_alias: attributes_for(:email_alias)
      response.should render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      EmailAlias.any_instance.stubs(:valid?).returns(true)
      post :create, email_domain_id: @email_domain.id, email_alias: attributes_for(:email_alias)
      response.should redirect_to(email_domain_email_aliases_path)
    end

    it 'edit action should render edit template' do
      get :edit, email_domain_id: @email_domain.id, id: EmailAlias.first
      response.should render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      EmailAlias.any_instance.stubs(:valid?).returns(false)
      put :update, email_domain_id: @email_domain.id, id: EmailAlias.first, email_alias: attributes_for(:email_alias)
      response.should render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      EmailAlias.any_instance.stubs(:valid?).returns(true)
      put :update, email_domain_id: @email_domain.id, id: EmailAlias.first, email_alias: attributes_for(:email_alias)
      response.should redirect_to(email_domain_email_aliases_path)
    end

    it 'destroy action should destroy model and redirect to index action' do
      email_alias = EmailAlias.first
      delete :destroy, email_domain_id: @email_domain.id, id: email_alias
      response.should redirect_to(email_domain_email_aliases_path)
      EmailAlias.exists?(email_alias.id).should be false
    end
  end
end
