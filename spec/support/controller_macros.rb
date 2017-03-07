# coding: utf-8

module ControllerMacros
  def login_user(model_class = nil)
    before(:each) { sign_in_user(create(:user), model_class) }
  end

  def login_admin_user(model_class = nil)
    before(:each) { sign_in_user(create(:admin_user), model_class) }
  end

  def it_should_raise_cancan_access_denied_for_actions(_controller, actions = {})
    actions.each do |action, method|
      it "#{action} action (with method #{method}) should require admin user" do
        -> { send(method, action, id: 1) }.should raise_error(CanCan::AccessDenied)
      end
    end
  end

  def it_should_require_admin_user_for_actions(controller, actions = {})
    actions.each do |action, method|
      it "#{action} action (with method #{method}) should require admin" do
        controller.any_instance.stubs(:fix_time_params)
        send(method, action, id: 1)
        response.should redirect_to(new_user_session_path)
        expect(flash[:alert])
          .to eq('Вы должны авторизоваться, чтобы продолжить')
      end
    end
  end
end
