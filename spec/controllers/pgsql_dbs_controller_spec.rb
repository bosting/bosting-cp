require 'spec_helper'

describe PgsqlDbsController do
  let!(:pgsql_user) { create(:pgsql_user_with_new_password) }
  let!(:pgsql_db) { create(:pgsql_db_with_similar_name, pgsql_user: pgsql_user) }

  render_views

  context 'as user' do
    login_user Apache

    it 'index action should render index template' do
      get :index, pgsql_user_id: pgsql_user.id
      expect(response).to render_template(:index)
    end

    it 'new action should render new template' do
      get :new, pgsql_user_id: pgsql_user.id
      expect(response).to render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      PgsqlDb.any_instance.stubs(:valid?).returns(false)
      post :create, pgsql_user_id: pgsql_user.id, pgsql_db: attributes_for(:pgsql_db)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      PgsqlDb.any_instance.stubs(:valid?).returns(true)
      post :create, pgsql_user_id: pgsql_user.id, pgsql_db: attributes_for(:pgsql_db)
      expect(response).to redirect_to(pgsql_user_pgsql_dbs_url)
    end

    it 'edit action should render edit template' do
      get :edit, pgsql_user_id: pgsql_user.id, id: pgsql_db
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      PgsqlDb.any_instance.stubs(:valid?).returns(false)
      put :update, pgsql_user_id: pgsql_user.id, id: pgsql_db, pgsql_db: attributes_for(:pgsql_db)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      PgsqlDb.any_instance.stubs(:valid?).returns(true)
      put :update, pgsql_user_id: pgsql_user.id, id: pgsql_db, pgsql_db: attributes_for(:pgsql_db)
      expect(response).to redirect_to(pgsql_user_pgsql_dbs_url)
    end

    it 'destroy action should destroy model and redirect to index action' do
      delete :destroy, pgsql_user_id: pgsql_user.id, id: pgsql_db
      expect(response).to redirect_to(pgsql_user_pgsql_dbs_url)
      PgsqlDb.exists?(pgsql_db.id).should be_falsey
    end
  end
end
