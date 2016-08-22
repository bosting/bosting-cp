class QuickRegistrationsController < ApplicationController
  def new
    @quick_registration = QuickRegistration.new(with_mysql: true, with_pgsql: false, with_ssh: true, with_ftp: true)
  end

  def create
    @quick_registration = QuickRegistration.new permitted_params
    if @quick_registration.process_registration
      redirect_to root_path, notice: t('flash.quick_registration.create')
    else
      render :new
    end
  end
end
