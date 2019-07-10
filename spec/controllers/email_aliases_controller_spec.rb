require 'spec_helper'

describe EmailAliasesController do
  let!(:email_domain) { create(:email_domain) }
  let!(:email_alias) { create(:email_alias, email_domain: email_domain) }

  render_views

  context 'as user' do
    login_user EmailDomain

    it 'index action should render index template' do
      get :index, email_domain_id: email_domain.id
      expect(response).to render_template(:index)
    end

    it 'new action should render new template' do
      get :new, email_domain_id: email_domain.id
      expect(response).to render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      EmailAlias.any_instance.stubs(:valid?).returns(false)
      post :create, email_domain_id: email_domain.id, email_alias: attributes_for(:email_alias)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      EmailAlias.any_instance.stubs(:valid?).returns(true)
      post :create, email_domain_id: email_domain.id, email_alias: attributes_for(:email_alias)
      expect(response).to redirect_to(email_domain_email_aliases_url)
    end

    it 'edit action should render edit template' do
      get :edit, email_domain_id: email_domain.id, id: email_alias
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      EmailAlias.any_instance.stubs(:valid?).returns(false)
      put :update, email_domain_id: email_domain.id, id: email_alias, email_alias: attributes_for(:email_alias)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      EmailAlias.any_instance.stubs(:valid?).returns(true)
      put :update, email_domain_id: email_domain.id, id: email_alias, email_alias: attributes_for(:email_alias)
      expect(response).to redirect_to(email_domain_email_aliases_url)
    end

    it 'destroy action should destroy model and redirect to index action' do
      delete :destroy, email_domain_id: email_domain.id, id: email_alias
      expect(response).to redirect_to(email_domain_email_aliases_url)
      EmailAlias.exists?(email_alias.id).should be false
    end
  end
end
