require 'spec_helper'

describe QuickRegistrationsController do
  let!(:ip_address) { create(:ip_address, name: 'ns1.example.com') }
  let!(:ip_address2) { create(:ip_address, name: 'ns2.example.com') }

  before { create_settings }

  render_views

  context 'as admin user' do
    login_admin_user

    it 'new action should render new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      QuickRegistration.any_instance.stubs(:process_registration).returns(false)
      post :create, quick_registration: attributes_for(:quick_registration)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      QuickRegistration.any_instance.stubs(:process_registration).returns(true)
      post :create, quick_registration: attributes_for(:quick_registration)
      expect(response).to redirect_to(root_url)
    end
  end
end
