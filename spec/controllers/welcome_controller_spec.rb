require 'spec_helper'

describe WelcomeController do
  render_views

  context 'as admin' do
    login_admin_user

    it 'index action should render index template' do
      get :index
      response.should render_template(:index)
    end
  end
end
