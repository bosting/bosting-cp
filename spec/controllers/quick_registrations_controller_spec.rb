require 'spec_helper'

describe QuickRegistrationsController do
  render_views
  before(:all) do
    create(:ip_address, name: 'ns1.hosting')
    create(:ip_address, name: 'ns2.hosting')
  end

  context 'as admin user' do
    login_admin_user

    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end

    it "create action should render new template when model is invalid" do
      QuickRegistration.any_instance.stubs(:process_registration).returns(false)
      post :create, quick_registration: attributes_for(:quick_registration)
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      QuickRegistration.any_instance.stubs(:process_registration).returns(true)
      post :create, quick_registration: attributes_for(:quick_registration)
      response.should redirect_to(root_path)
    end
  end
end
