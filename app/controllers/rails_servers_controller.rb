class RailsServersController < ApplicationController
  load_and_authorize_resource except: :create

  def index
  end

  def new
  end

  def edit
  end

  def create
    authorize! :create, @rails_server = RailsServer.new(permitted_params)
    if @rails_server.save
      redirect_to rails_servers_path, notice: t('flash.rails_server.create')
    else
      render :new
    end
  end

  def update
    @rails_server = RailsServer.find(params[:id])
    if @rails_server.update(permitted_params)
      redirect_to rails_servers_path, notice: t('flash.rails_server.update')
    else
      render :edit
    end
  end

  def destroy
    @rails_server.destroy
    redirect_to rails_servers_path, notice: t('flash.rails_server.destroy')
  end
end
