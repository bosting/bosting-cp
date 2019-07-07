require 'spec_helper'

describe VhostsController do
  let!(:apache) { create(:apache) }
  let!(:vhost) { create(:vhost, apache: apache) }

  render_views

  context 'as user' do
    login_user Apache

    it 'index action should render index template' do
      get :index, apache_id: apache.id
      expect(response).to render_template(:index)
    end

    it 'new action should render new template' do
      create_settings
      get :new, apache_id: apache.id
      expect(response).to render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      Vhost.any_instance.stubs(:valid?).returns(false)
      post :create, apache_id: apache.id, vhost: params_for(:vhost)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      Vhost.any_instance.stubs(:valid?).returns(true)
      post :create, apache_id: apache.id, vhost: params_for(:vhost)
      expect(response).to redirect_to(apache_vhosts_url(apache))
    end

    it 'edit action should render edit template' do
      get :edit, id: vhost, apache_id: apache.id
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      Vhost.any_instance.stubs(:valid?).returns(false)
      put :update, id: vhost, apache_id: apache.id, vhost: params_for(:vhost)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      Vhost.any_instance.stubs(:valid?).returns(true)
      put :update, id: vhost, apache_id: apache.id, vhost: params_for(:vhost)
      expect(response).to redirect_to(apache_vhosts_url(apache))
    end

    it 'destroy action should destroy model and redirect to index action' do
      delete :destroy, id: vhost, apache_id: apache.id
      expect(response).to redirect_to(apache_vhosts_url(apache))
      Vhost.exists?(vhost.id).should be_falsey
    end
  end
end
