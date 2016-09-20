require 'spec_helper'

describe RailsServersController do
  before(:all) do
    2.times { create(:rails_server) }
  end
  render_views

  context 'as admin user' do
    login_user RailsServer

    it "index action should render index template" do
      get :index
      response.should render_template(:index)
    end

    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end

    it "create action should render new template when model is invalid" do
      RailsServer.any_instance.stubs(:valid?).returns(false)
      post :create, rails_server: params_for(:rails_server)
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      RailsServer.any_instance.stubs(:valid?).returns(true)
      post :create, rails_server: params_for(:rails_server)
      response.should redirect_to(rails_servers_path)
    end

    it "edit action should render edit template" do
      get :edit, id: RailsServer.first
      response.should render_template(:edit)
    end

    it "update action should render edit template when model is invalid" do
      RailsServer.any_instance.stubs(:valid?).returns(false)
      put :update, id: RailsServer.first, rails_server: params_for(:rails_server)
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      RailsServer.any_instance.stubs(:valid?).returns(true)
      put :update, id: RailsServer.first, rails_server: params_for(:rails_server)
      response.should redirect_to(rails_servers_path)
    end

    it "destroy action should destroy model and redirect to index action" do
      rails_server = RailsServer.first
      delete :destroy, id: rails_server
      response.should redirect_to(rails_servers_path)
      RailsServer.exists?(rails_server.id).should be_falsey
    end
  end
end
