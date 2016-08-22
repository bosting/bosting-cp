class RegistrarsController < ApplicationController
  load_and_authorize_resource except: :create

  def index
  end

  def new
  end

  def create
    authorize! :create, @registrar = Registrar.new(permitted_params)
    if @registrar.save
      redirect_to registrars_path, notice: t('flash.registrar.create')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @registrar.update(permitted_params)
      redirect_to registrars_path, notice: t('flash.registrar.update')
    else
      render :edit
    end
  end

  def destroy
    @registrar.destroy
    redirect_to registrars_path, notice: t('flash.registrar.destroy')
  end
end
