class ApachesController < ApplicationController
  load_and_authorize_resource except: :create

  def index
    @apaches = Apache.search domain: params[:domain]
    @can_destroy = can? :destroy, Apache
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
      redirect_to apaches_path, notice: t('flash.apache.update')
    else
      render :edit
    end
  end

  def destroy
    params = permitted_params
    @apache.destroy_domains = params['destroy_domains']
    @apache.destroy_ftps = params['destroy_ftps']
    @apache.destroy_user = params['destroy_user']
    @apache.destroy_system_user = params['destroy_system_user']
    @apache.destroy_mysql_users = params['destroy_mysql_users']
    @apache.destroy_pgsql_users = params['destroy_pgsql_users']
    @apache.destroy
    redirect_to apaches_path, notice: t('flash.apache.destroy')
  end

  def before_destroy
    @apache.destroy_domains = true
    @apache.destroy_ftps = true
    @apache.destroy_user = true
    @apache.destroy_system_user = true
    @apache.destroy_mysql_users = true
    @apache.destroy_pgsql_users = true
  end
end
