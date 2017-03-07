require 'spec_helper'

describe PgsqlUsersController do
  before(:all) do
    2.times { create(:pgsql_user_with_new_password) }
  end
  render_views

  context 'as admin user' do
    login_admin_user

    it 'new action should render new template' do
      get :new
      response.should render_template(:new)
    end

    it 'update action should render edit template when model is invalid' do
      PgsqlUser.any_instance.stubs(:valid?).returns(false)
      put :update, id: PgsqlUser.first, pgsql_user: params_for(:pgsql_user)
      response.should render_template(:edit)
    end
  end

  context 'as user' do
    login_user Apache

    it 'index action should render index template' do
      get :index
      response.should render_template(:index)
    end

    it 'new action should render new template' do
      get :new
      response.should render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      PgsqlUser.any_instance.stubs(:valid?).returns(false)
      post :create, pgsql_user: params_for(:pgsql_user)
      response.should render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      PgsqlUser.any_instance.stubs(:valid?).returns(true)
      post :create, pgsql_user: params_for(:pgsql_user)
      response.should redirect_to(pgsql_users_path)
      expect(PgsqlUser.last.pgsql_dbs).to match_array([])
    end

    it 'should create a db with the same name' do
      PgsqlUser.any_instance.stubs(:valid?).returns(true)
      post :create, pgsql_user: params_for(:pgsql_user, merge_attrs: { create_db: '1' })
      response.should redirect_to(pgsql_users_path)
      PgsqlUser.last.pgsql_dbs.first.should be_an_kind_of(PgsqlDb)
    end

    it 'edit action should render edit template' do
      get :edit, id: PgsqlUser.first
      response.should render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      PgsqlUser.any_instance.stubs(:valid?).returns(false)
      put :update, id: PgsqlUser.first, pgsql_user: params_for(:pgsql_user)
      response.should render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      PgsqlUser.any_instance.stubs(:valid?).returns(true)
      put :update, id: PgsqlUser.first, pgsql_user: params_for(:pgsql_user)
      response.should redirect_to(pgsql_users_path)
    end

    it 'destroy action should destroy model and redirect to index action' do
      pgsql_user = PgsqlUser.first
      delete :destroy, id: pgsql_user
      response.should redirect_to(pgsql_users_path)
      PgsqlUser.exists?(pgsql_user.id).should be_falsey
    end
  end
end
