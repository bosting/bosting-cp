class SystemGroupsController < ApplicationController
  load_and_authorize_resource except: :create

  def index
  end

  def new
  end

  def create
    authorize! :create, @system_group = SystemGroup.new(permitted_params)
    if @system_group.save
      redirect_to system_groups_path, notice: t('flash.system_group.create')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @system_group.update(permitted_params)
      redirect_to system_groups_path, notice: t('flash.system_group.update')
    else
      render :edit
    end
  end

  def destroy
    @system_group.destroy
    redirect_to system_groups_path, notice: t('flash.system_group.destroy')
  end
end
