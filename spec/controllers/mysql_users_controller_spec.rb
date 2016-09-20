require 'spec_helper'

describe MysqlUsersController do
  before(:all) do
    2.times { create(:mysql_user_with_new_password) }
  end
  render_views

  context 'as admin user' do
    login_admin_user

    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end

    it "update action should render edit template when model is invalid" do
      MysqlUser.any_instance.stubs(:valid?).returns(false)
      put :update, id: MysqlUser.first, mysql_user: params_for(:mysql_user)
      response.should render_template(:edit)
    end
  end

  context 'as user' do
    login_user Apache

    it "index action should render index template" do
      get :index
      response.should render_template(:index)
    end

    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end

    it "create action should render new template when model is invalid" do
      MysqlUser.any_instance.stubs(:valid?).returns(false)
      post :create, mysql_user: params_for(:mysql_user)
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      MysqlUser.any_instance.stubs(:valid?).returns(true)
      post :create, mysql_user: params_for(:mysql_user)
      response.should redirect_to(mysql_users_path)
    end

    it "edit action should render edit template" do
      get :edit, id: MysqlUser.first
      response.should render_template(:edit)
    end

    it "update action should render edit template when model is invalid" do
      MysqlUser.any_instance.stubs(:valid?).returns(false)
      put :update, id: MysqlUser.first, mysql_user: params_for(:mysql_user)
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      MysqlUser.any_instance.stubs(:valid?).returns(true)
      put :update, id: MysqlUser.first, mysql_user: params_for(:mysql_user)
      response.should redirect_to(mysql_users_path)
    end

    it "destroy action should destroy model and redirect to index action" do
      mysql_user = MysqlUser.first
      delete :destroy, id: mysql_user
      response.should redirect_to(mysql_users_path)
      MysqlUser.exists?(mysql_user.id).should be_falsey
    end
  end
end
