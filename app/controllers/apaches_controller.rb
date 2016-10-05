class ApachesController < ApplicationController
  load_and_authorize_resource except: :create

  def index
    @apaches = Apache.search domain: params[:domain]
    @can_destroy = can?(:new, ApacheDestruction)
  end

  def new
    @apache.set_defaults
  end

  def edit
  end

  def create
    authorize! :create, @apache = Apache.new(permitted_params)
    if @apache.save
      @apache.create_chef_task(:create)
      redirect_to apaches_path, notice: t('flash.apache.create')
    else
      render :new
    end
  end

  def update
    if @apache.update(permitted_params)
      @apache.create_chef_task(:create)
      @apache.create_crontab_migration
      redirect_to apaches_path, notice: t('flash.apache.update')
    else
      render :edit
    end
  end
end
