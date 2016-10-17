require 'spec_helper'

describe SettingsController do
  before(:all) { 2.times { create(:setting) } }
  render_views

  context 'as admin user' do
    login_admin_user

    it 'index action should render index template' do
      get :index
      response.should render_template(:index)
    end

    it 'edit action should render edit template' do
      get :edit, id: Setting.first, setting: params_for(:setting)
      response.should render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      Setting.any_instance.stubs(:valid?).returns(false)
      put :update, id: Setting.first, setting: params_for(:setting)
      response.should render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      Setting.any_instance.stubs(:valid?).returns(true)
      put :update, id: Setting.first, setting: params_for(:setting)
      response.should redirect_to(settings_path)
    end
  end
end
