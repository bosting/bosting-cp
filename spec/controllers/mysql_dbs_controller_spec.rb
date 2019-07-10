require 'spec_helper'

describe MysqlDbsController do
  let!(:mysql_user) { create(:mysql_user_with_new_password) }
  let!(:mysql_db) { create(:mysql_db_with_similar_name, mysql_user: mysql_user) }

  render_views

  context 'as user' do
    login_user Apache

    it 'index action should render index template' do
      get :index, mysql_user_id: mysql_user.id
      expect(response).to render_template(:index)
    end

    it 'new action should render new template' do
      get :new, mysql_user_id: mysql_user.id
      expect(response).to render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      MysqlDb.any_instance.stubs(:valid?).returns(false)
      post :create, mysql_user_id: mysql_user.id, mysql_db: attributes_for(:mysql_db)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      MysqlDb.any_instance.stubs(:valid?).returns(true)
      post :create, mysql_user_id: mysql_user.id, mysql_db: attributes_for(:mysql_db)
      expect(response).to redirect_to(mysql_user_mysql_dbs_path)
    end

    it 'edit action should render edit template' do
      get :edit, mysql_user_id: mysql_user.id, id: mysql_db
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      MysqlDb.any_instance.stubs(:valid?).returns(false)
      put :update, mysql_user_id: mysql_user.id, id: mysql_db, mysql_db: attributes_for(:mysql_db)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      MysqlDb.any_instance.stubs(:valid?).returns(true)
      put :update, mysql_user_id: mysql_user.id, id: mysql_db, mysql_db: attributes_for(:mysql_db)
      expect(response).to redirect_to(mysql_user_mysql_dbs_path)
    end

    it 'destroy action should destroy model and redirect to index action' do
      delete :destroy, mysql_user_id: mysql_user.id, id: mysql_db
      expect(response).to redirect_to(mysql_user_mysql_dbs_path)
      MysqlDb.exists?(mysql_db.id).should be_falsey
    end
  end
end
