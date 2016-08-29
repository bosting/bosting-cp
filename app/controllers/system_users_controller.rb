class SystemUsersController < ApplicationController
  load_and_authorize_resource except: :create

  def index
    @system_users = @system_users.not_deleted
    @can_destroy = can? :destroy, SystemUser
  end

  def new
    @system_user.set_defaults
  end

  def create
    authorize! :create, @system_user = SystemUser.new(permitted_params)
    if @system_user.save
      @system_user.create_chef_task(:create)
      redirect_to system_users_path, notice: t('flash.system_user.create')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @system_user.update(permitted_params)
      @system_user.create_chef_task(:create)
      redirect_to system_users_path, notice: t('flash.system_user.update')
    else
      render :edit
    end
  end

  def destroy
    @system_user.destroy
    @system_user.create_chef_task(:destroy)
    redirect_to system_users_path, notice: t('flash.system_user.destroy')
  end
end
