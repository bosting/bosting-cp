class IpAddressesController < ApplicationController
  load_and_authorize_resource except: :create

  def index
  end

  def new
  end

  def create
    authorize! :create, @ip_address = IpAddress.new(permitted_params)
    if @ip_address.save
      redirect_to ip_addresses_path, notice: t('flash.ip_address.create')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @ip_address.update(permitted_params)
      redirect_to ip_addresses_path, notice: t('flash.ip_address.update')
    else
      render :edit
    end
  end

  def destroy
    @ip_address.destroy
    redirect_to ip_addresses_path, notice: t('flash.ip_address.destroy')
  end
end
