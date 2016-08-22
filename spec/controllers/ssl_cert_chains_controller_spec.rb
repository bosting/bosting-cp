require 'spec_helper'

describe SslCertChainsController do
  before(:all) do
    2.times { create(:ssl_cert_chain) }
  end
  render_views

  context 'as admin user' do
    login_admin_user

    it "index action should render index template" do
      get :index
      response.should render_template(:index)
    end

    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end

    it "create action should render new template when model is invalid" do
      SslCertChain.any_instance.stubs(:valid?).returns(false)
      post :create, ssl_cert_chain: attributes_for(:ssl_cert_chain)
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      SslCertChain.any_instance.stubs(:valid?).returns(true)
      post :create, ssl_cert_chain: attributes_for(:ssl_cert_chain)
      response.should redirect_to(ssl_cert_chains_path)
    end

    it "edit action should render edit template" do
      get :edit, id: SslCertChain.first
      response.should render_template(:edit)
    end

    it "update action should render edit template when model is invalid" do
      SslCertChain.any_instance.stubs(:valid?).returns(false)
      put :update, id: SslCertChain.first, ssl_cert_chain: attributes_for(:ssl_cert_chain)
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      SslCertChain.any_instance.stubs(:valid?).returns(true)
      put :update, id: SslCertChain.first, ssl_cert_chain: attributes_for(:ssl_cert_chain)
      response.should redirect_to(ssl_cert_chains_path)
    end

    it "destroy action should destroy model and redirect to index action" do
      ssl_cert_chain = SslCertChain.first
      delete :destroy, id: ssl_cert_chain
      response.should redirect_to(ssl_cert_chains_path)
      SslCertChain.exists?(ssl_cert_chain.id).should be_falsey
    end
  end
end
