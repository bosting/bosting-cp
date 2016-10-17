require 'spec_helper'

describe VhostsController do
  before(:all) do
    @apache = create(:apache)
    2.times { create(:vhost, apache: @apache) }
  end
  render_views

  context 'as user' do
    login_user Apache

    it 'index action should render index template' do
      get :index, apache_id: @apache.id
      response.should render_template(:index)
    end

    it 'new action should render new template' do
      get :new, apache_id: @apache.id
      response.should render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      Vhost.any_instance.stubs(:valid?).returns(false)
      post :create, apache_id: @apache.id, vhost: params_for(:vhost)
      response.should render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      Vhost.any_instance.stubs(:valid?).returns(true)
      post :create, apache_id: @apache.id, vhost: params_for(:vhost)
      response.should redirect_to(apache_vhosts_path(@apache))
    end

    it 'edit action should render edit template' do
      get :edit, id: Vhost.first, apache_id: @apache.id
      response.should render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      Vhost.any_instance.stubs(:valid?).returns(false)
      put :update, id: Vhost.first, apache_id: @apache.id, vhost: params_for(:vhost)
      response.should render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      Vhost.any_instance.stubs(:valid?).returns(true)
      put :update, id: Vhost.first, apache_id: @apache.id, vhost: params_for(:vhost)
      response.should redirect_to(apache_vhosts_path(@apache))
    end

    it 'destroy action should destroy model and redirect to index action' do
      vhost = Vhost.first
      delete :destroy, id: vhost, apache_id: @apache.id
      response.should redirect_to(apache_vhosts_path(@apache))
      Vhost.exists?(vhost.id).should be_falsey
    end
  end
end
