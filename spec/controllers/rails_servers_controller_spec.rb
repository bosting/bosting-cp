require 'spec_helper'

describe RailsServersController do
  let!(:rails_server) { create(:rails_server) }

  render_views

  context 'as admin user' do
    login_user RailsServer

    it 'index action should render index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'new action should render new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      RailsServer.any_instance.stubs(:valid?).returns(false)
      post :create, rails_server: params_for(:rails_server)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      RailsServer.any_instance.stubs(:valid?).returns(true)
      post :create, rails_server: params_for(:rails_server)
      expect(response).to redirect_to(rails_servers_url)
    end

    it 'edit action should render edit template' do
      get :edit, id: rails_server
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      RailsServer.any_instance.stubs(:valid?).returns(false)
      put :update, id: rails_server, rails_server: params_for(:rails_server)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      RailsServer.any_instance.stubs(:valid?).returns(true)
      put :update, id: rails_server, rails_server: params_for(:rails_server)
      expect(response).to redirect_to(rails_servers_url)
    end

    it 'destroy action should destroy model and redirect to index action' do
      delete :destroy, id: rails_server
      expect(response).to redirect_to(rails_servers_url)
      RailsServer.exists?(rails_server.id).should be_falsey
    end
  end
end
