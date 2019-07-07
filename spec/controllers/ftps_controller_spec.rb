require 'spec_helper'

describe FtpsController do
  let!(:ftp) { create(:ftp) }

  render_views

  context 'as admin user' do
    login_admin_user

    it 'new action should render new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'update action should render edit template when model is invalid' do
      Ftp.any_instance.stubs(:valid?).returns(false)
      put :update, id: ftp, ftp: params_for(:ftp)
      expect(response).to render_template(:edit)
    end
  end

  context 'as user' do
    login_user SystemUser

    it 'index action should render index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'new action should render new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      Ftp.any_instance.stubs(:valid?).returns(false)
      post :create, ftp: params_for(:ftp)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      Ftp.any_instance.stubs(:valid?).returns(true)
      post :create, ftp: params_for(:ftp)
      expect(response).to redirect_to(ftps_url)
    end

    it 'edit action should render edit template' do
      get :edit, id: ftp
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      Ftp.any_instance.stubs(:valid?).returns(false)
      put :update, id: ftp, ftp: params_for(:ftp)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      Ftp.any_instance.stubs(:valid?).returns(true)
      put :update, id: ftp, ftp: params_for(:ftp)
      expect(response).to redirect_to(ftps_url)
    end

    it 'destroy action should destroy model and redirect to index action' do
      delete :destroy, id: ftp
      expect(response).to redirect_to(ftps_url)
      Ftp.exists?(ftp.id).should be_falsey
    end
  end
end
