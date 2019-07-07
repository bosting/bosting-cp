require 'spec_helper'

describe IpAddressesController do
  let!(:ip_address) { create(:ip_address) }

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
      IpAddress.any_instance.stubs(:valid?).returns(false)
      post :create, ip_address: attributes_for(:ip_address)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      IpAddress.any_instance.stubs(:valid?).returns(true)
      post :create, ip_address: attributes_for(:ip_address)
      expect(response).to redirect_to(ip_addresses_path)
    end

    it 'edit action should render edit template' do
      get :edit, id: ip_address
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      IpAddress.any_instance.stubs(:valid?).returns(false)
      put :update, id: ip_address, ip_address: attributes_for(:ip_address)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      IpAddress.any_instance.stubs(:valid?).returns(true)
      put :update, id: ip_address, ip_address: attributes_for(:ip_address)
      expect(response).to redirect_to(ip_addresses_path)
    end

    it 'destroy action should destroy model and redirect to index action' do
      delete :destroy, id: ip_address
      expect(response).to redirect_to(ip_addresses_path)
      IpAddress.exists?(ip_address.id).should be_falsey
    end
  end
end
