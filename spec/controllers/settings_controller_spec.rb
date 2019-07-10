require 'spec_helper'

describe SettingsController do
  let!(:setting) { create(:setting) }

  render_views

  context 'as admin user' do
    login_admin_user

    it 'index action should render index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'edit action should render edit template' do
      get :edit, id: setting, setting: params_for(:setting)
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      Setting.any_instance.stubs(:valid?).returns(false)
      put :update, id: setting, setting: params_for(:setting)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      Setting.any_instance.stubs(:valid?).returns(true)
      put :update, id: setting, setting: params_for(:setting)
      expect(response).to redirect_to(settings_url)
    end
  end
end
