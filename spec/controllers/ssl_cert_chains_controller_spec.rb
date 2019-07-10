require 'spec_helper'

describe SslCertChainsController do
  let!(:ssl_cert_chain) { create(:ssl_cert_chain) }

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
      SslCertChain.any_instance.stubs(:valid?).returns(false)
      post :create, ssl_cert_chain: attributes_for(:ssl_cert_chain)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      SslCertChain.any_instance.stubs(:valid?).returns(true)
      post :create, ssl_cert_chain: attributes_for(:ssl_cert_chain)
      expect(response).to redirect_to(ssl_cert_chains_url)
    end

    it 'edit action should render edit template' do
      get :edit, id: ssl_cert_chain
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      SslCertChain.any_instance.stubs(:valid?).returns(false)
      put :update, id: ssl_cert_chain, ssl_cert_chain: attributes_for(:ssl_cert_chain)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      SslCertChain.any_instance.stubs(:valid?).returns(true)
      put :update, id: ssl_cert_chain, ssl_cert_chain: attributes_for(:ssl_cert_chain)
      expect(response).to redirect_to(ssl_cert_chains_url)
    end

    it 'destroy action should destroy model and redirect to index action' do
      delete :destroy, id: ssl_cert_chain
      expect(response).to redirect_to(ssl_cert_chains_url)
      SslCertChain.exists?(ssl_cert_chain.id).should be_falsey
    end
  end
end
