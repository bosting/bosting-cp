require 'spec_helper'

describe MysqlUsersController do
  before(:all) do
    2.times { create(:mysql_user_with_new_password) }
  end
  render_views

  context 'as admin user' do
    login_admin_user

    it 'new action should render new template' do
      get :new
      response.should render_template(:new)
    end

    it 'update action should render edit template when model is invalid' do
      MysqlUser.any_instance.stubs(:valid?).returns(false)
      put :update, id: MysqlUser.first, mysql_user: params_for(:mysql_user)
      expect(response).to render_template(:edit)
    end
  end

  context 'as user' do
    login_user Apache

    it 'index action should render index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'new action should render new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      MysqlUser.any_instance.stubs(:valid?).returns(false)
      post :create, mysql_user: params_for(:mysql_user)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      MysqlUser.any_instance.stubs(:valid?).returns(true)
      post :create, mysql_user: params_for(:mysql_user)
      expect(response).to redirect_to(mysql_users_path)
      expect(MysqlUser.last.mysql_dbs).to match_array([])
    end

    it 'should create a db with the same name' do
      MysqlUser.any_instance.stubs(:valid?).returns(true)
      post :create, mysql_user: params_for(:mysql_user, merge_attrs: { create_db: '1' })
      expect(response).to redirect_to(mysql_users_path)
      expect(MysqlUser.last.mysql_dbs.first).to be_an_kind_of(MysqlDb)
    end

    it 'edit action should render edit template' do
      get :edit, id: MysqlUser.first
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      MysqlUser.any_instance.stubs(:valid?).returns(false)
      put :update, id: MysqlUser.first, mysql_user: params_for(:mysql_user)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      MysqlUser.any_instance.stubs(:valid?).returns(true)
      put :update, id: MysqlUser.first, mysql_user: params_for(:mysql_user)
      expect(response).to redirect_to(mysql_users_path)
    end

    it 'destroy action should destroy model and redirect to index action' do
      mysql_user = MysqlUser.first
      delete :destroy, id: mysql_user
      expect(response).to redirect_to(mysql_users_path)
      expect(MysqlUser.exists?(mysql_user.id)).to be false
    end
  end
end
