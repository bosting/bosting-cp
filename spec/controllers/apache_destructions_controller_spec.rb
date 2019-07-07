require 'spec_helper'

describe ApacheDestructionsController do
  let(:apache) { create(:apache) }

  render_views

  context 'as admin user' do
    login_admin_user

    it 'new action should render new template' do
      get :new, apache_id: apache.id
      expect(response).to render_template(:new)
    end

    it 'create action should redirect' do
      post :create, apache_id: apache.id, apache_destruction: attributes_for(:apache_destruction)
      expect(response).to redirect_to(apaches_url)
    end
  end
end
