class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def memoize_permitted_params
    @permitted_params ||= PermittedParams.new(params, current_user)
  end

  def permitted_params
    memoize_permitted_params
    @permitted_params.permitted_params
  end

  def permitted_attributes model_name
    memoize_permitted_params
    @permitted_params.permitted_attributes model_name
  end
  helper_method :permitted_attributes
end
