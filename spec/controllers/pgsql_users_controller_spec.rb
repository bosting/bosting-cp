require 'spec_helper'

describe PgsqlUsersController do
  let!(:pgsql_user) { create(:pgsql_user_with_new_password) }

  render_views

  context 'as admin user' do
    login_admin_user

    it 'new action should render new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'update action should render edit template when model is invalid' do
      PgsqlUser.any_instance.stubs(:valid?).returns(false)
      put :update, id: pgsql_user, pgsql_user: params_for(:pgsql_user)
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
      PgsqlUser.any_instance.stubs(:valid?).returns(false)
      post :create, pgsql_user: params_for(:pgsql_user)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      PgsqlUser.any_instance.stubs(:valid?).returns(true)
      post :create, pgsql_user: params_for(:pgsql_user)
      expect(response).to redirect_to(pgsql_users_url)
      expect(PgsqlUser.last.pgsql_dbs).to match_array([])
    end

    it 'should create a db with the same name' do
      PgsqlUser.any_instance.stubs(:valid?).returns(true)
      post :create, pgsql_user: params_for(:pgsql_user, merge_attrs: { create_db: '1' })
      expect(response).to redirect_to(pgsql_users_url)
      PgsqlUser.last.pgsql_dbs.first.should be_an_kind_of(PgsqlDb)
    end

    it 'edit action should render edit template' do
      get :edit, id: pgsql_user
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      PgsqlUser.any_instance.stubs(:valid?).returns(false)
      put :update, id: pgsql_user, pgsql_user: params_for(:pgsql_user)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      PgsqlUser.any_instance.stubs(:valid?).returns(true)
      put :update, id: pgsql_user, pgsql_user: params_for(:pgsql_user)
      expect(response).to redirect_to(pgsql_users_url)
    end

    it 'destroy action should destroy model and redirect to index action' do
      delete :destroy, id: pgsql_user
      expect(response).to redirect_to(pgsql_users_url)
      PgsqlUser.exists?(pgsql_user.id).should be_falsey
    end
  end
end
