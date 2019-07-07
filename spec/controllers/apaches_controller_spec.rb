require 'spec_helper'

describe ApachesController do
  let!(:apache) { create(:apache) }

  render_views

  context 'as user' do
    login_user Apache

    it 'index action should render index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'edit action should render edit template' do
      get :edit, id: apache
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      Apache.any_instance.stubs(:valid?).returns(false)
      put :update, id: apache, apache: params_for(:apache)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      Apache.any_instance.stubs(:valid?).returns(true)
      put :update, id: apache, apache: params_for(:apache)
      expect(response).to redirect_to(apaches_path)
    end
  end

  context 'as admin user' do
    login_admin_user

    it 'new action should render new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      Apache.any_instance.stubs(:valid?).returns(false)
      post :create, apache: params_for(:apache)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      Apache.any_instance.stubs(:valid?).returns(true)
      post :create, apache: params_for(:apache)
      expect(response).to redirect_to(apaches_path)
    end
  end
end
