require 'spec_helper'

describe EmailUsersController do
  let!(:email_domain) { create(:email_domain) }
  let!(:email_user) { create(:email_user, email_domain: email_domain) }

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
      EmailUser.any_instance.stubs(:valid?).returns(false)
      post :create, email_domain_id: email_domain.id, email_user: attributes_for(:email_user)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      EmailUser.any_instance.stubs(:valid?).returns(true)
      post :create, email_domain_id: email_domain.id, email_user: attributes_for(:email_user)
      expect(response).to redirect_to(email_domain_email_users_url)
    end

    it 'edit action should render edit template' do
      get :edit, email_domain_id: email_domain.id, id: email_user
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      EmailUser.any_instance.stubs(:valid?).returns(false)
      put :update, email_domain_id: email_domain.id, id: email_user, email_user: attributes_for(:email_user)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      EmailUser.any_instance.stubs(:valid?).returns(true)
      put :update, email_domain_id: email_domain.id, id: email_user, email_user: attributes_for(:email_user)
      expect(response).to redirect_to(email_domain_email_users_url)
    end

    it 'destroy action should destroy model and redirect to index action' do
      delete :destroy, email_domain_id: email_domain.id, id: email_user
      expect(response).to redirect_to(email_domain_email_users_url)
      EmailUser.exists?(email_user.id).should be false
    end
  end
end
