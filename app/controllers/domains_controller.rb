class DomainsController < ApplicationController
  load_and_authorize_resource except: :create

  def index
    @domains = @domains.includes(:ns1_ip_address, :ns2_ip_address)
    @can_destroy = can? :destroy, Domain
  end

  def new
    @domain.set_defaults
  end

  def edit
  end

  def create
    authorize! :create, @domain = Domain.new(permitted_params)
    if @domain.save
        redirect_to domains_path, notice: t('flash.domain.create')
    else
      render :new
    end
  end

  def update
    if @domain.update(permitted_params)
      redirect_to domains_path, notice: t('flash.domain.update')
    else
      render :edit
    end
  end

  def destroy
    @domain.destroy
    redirect_to domains_path, notice: t('flash.domain.destroy')
  end
end
