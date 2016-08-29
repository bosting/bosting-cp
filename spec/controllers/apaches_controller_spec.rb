require 'spec_helper'

describe ApachesController do
  before(:all) do
    2.times { create(:apache) }
  end
  render_views

  context 'as user' do
    login_user Apache

    it "index action should render index template" do
      get :index
      response.should render_template(:index)
    end

    it "edit action should render edit template" do
      get :edit, id: Apache.first
      response.should render_template(:edit)
    end

    it "update action should render edit template when model is invalid" do
      Apache.any_instance.stubs(:valid?).returns(false)
      put :update, id: Apache.first, apache: params_for(:apache)
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      Apache.any_instance.stubs(:valid?).returns(true)
      put :update, id: Apache.first, apache: params_for(:apache)
      response.should redirect_to(apaches_path)
    end
  end

  context 'as admin user' do
    login_admin_user

    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end

    it "create action should render new template when model is invalid" do
      Apache.any_instance.stubs(:valid?).returns(false)
      post :create, apache: params_for(:apache)
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      Apache.any_instance.stubs(:valid?).returns(true)
      post :create, apache: params_for(:apache)
      response.should redirect_to(apaches_path)
    end

    it "before destroy action should render its template" do
      apache = Apache.first
      get :before_destroy, id: apache
      response.should render_template(:before_destroy)
    end

    it "destroy action should mark model as deleted and redirect to index action" do
      apache = Apache.first
      delete :destroy, id: apache, apache: { something: 'something' }
      response.should redirect_to(apaches_path)
      Apache.exists?(apache.id).should be_truthy
      apache.reload.is_deleted.should be_truthy
    end
  end
end
