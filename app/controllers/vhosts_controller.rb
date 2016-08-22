class VhostsController < ApplicationController
  load_and_authorize_resource :apache
  load_and_authorize_resource :vhost, through: :apache, except: :create

  def index
    @vhosts = @vhosts.not_deleted
  end

  def new
    @vhost.set_defaults
  end

  def edit
  end

  def create
    authorize! :create, @vhost = @apache.vhosts.build(permitted_params)
    if @vhost.save
        redirect_to apache_vhosts_path(@apache), notice: t('flash.vhost.create')
    else
      render :new
    end
  end

  def update
    if @vhost.update(permitted_params)
      redirect_to apache_vhosts_path(@apache), notice: t('flash.vhost.update')
    else
      render :edit
    end
  end

  def destroy
    @vhost.destroy
    redirect_to apache_vhosts_path(@apache), notice: t('flash.vhost.destroy')
  end
end
