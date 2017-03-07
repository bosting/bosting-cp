require 'spec_helper'

describe IpAddressesController do
  before(:all) do
    2.times { create(:ip_address) }
  end
  render_views

  context 'as admin user' do
    login_admin_user

    it 'index action should render index template' do
      get :index
      response.should render_template(:index)
    end

    it 'new action should render new template' do
      get :new
      response.should render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      IpAddress.any_instance.stubs(:valid?).returns(false)
      post :create, ip_address: attributes_for(:ip_address)
      response.should render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      IpAddress.any_instance.stubs(:valid?).returns(true)
      post :create, ip_address: attributes_for(:ip_address)
      response.should redirect_to(ip_addresses_path)
    end

    it 'edit action should render edit template' do
      get :edit, id: IpAddress.first
      response.should render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      IpAddress.any_instance.stubs(:valid?).returns(false)
      put :update, id: IpAddress.first, ip_address: attributes_for(:ip_address)
      response.should render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      IpAddress.any_instance.stubs(:valid?).returns(true)
      put :update, id: IpAddress.first, ip_address: attributes_for(:ip_address)
      response.should redirect_to(ip_addresses_path)
    end

    it 'destroy action should destroy model and redirect to index action' do
      ip_address = IpAddress.first
      delete :destroy, id: ip_address
      response.should redirect_to(ip_addresses_path)
      IpAddress.exists?(ip_address.id).should be_falsey
    end
  end
end
