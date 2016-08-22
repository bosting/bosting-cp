module ControllerHelpers
  def sign_in_user user, model_class
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    if model_class
      model_class.any_instance.stubs(:user_id).returns(subject.current_user.id)
      model_class.any_instance.stubs(:user).returns(subject.current_user)
    end
  end
end
