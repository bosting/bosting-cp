class SystemUserShellsController < ApplicationController
  load_and_authorize_resource except: :create

  def index
  end

  def new
  end

  def edit
  end

  def create
    authorize! :create, @system_user_shell = SystemUserShell.new(permitted_params)
    if @system_user_shell.save
        redirect_to system_user_shells_path, notice: t('flash.system_user_shell.create')
    else
      render :new
    end
  end

  def update
    @system_user_shell = SystemUserShell.find(params[:id])
    if @system_user_shell.update(permitted_params)
      redirect_to system_user_shells_path, notice: t('flash.system_user_shell.update')
    else
      render :edit
    end
  end

  def destroy
    @system_user_shell.destroy
    redirect_to system_user_shells_path, notice: t('flash.system_user_shell.destroy')
  end
end
