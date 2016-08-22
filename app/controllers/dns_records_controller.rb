class DnsRecordsController < ApplicationController
  load_and_authorize_resource :domain
  load_and_authorize_resource :dns_record, through: :domain, except: :create

  def index
  end

  def new
  end

  def edit
  end

  def create
    authorize! :create, @dns_record = @domain.dns_records.build(permitted_params)
    if @dns_record.save
        redirect_to domain_dns_records_path(@domain), notice: t('flash.dns_record.create')
    else
      render :new
    end
  end

  def update
    if @dns_record.update(permitted_params)
      redirect_to domain_dns_records_path(@domain), notice: t('flash.dns_record.update')
    else
      render :edit
    end
  end

  def destroy
    @dns_record.destroy
    redirect_to domain_dns_records_path(@domain), notice: t('flash.dns_record.destroy')
  end
end
