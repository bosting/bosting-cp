class EmailDomainsController < ApplicationController
  load_and_authorize_resource except: :create

  def index
    @can_edit = can? :edit, EmailDomain
  end

  def new
  end

  def edit
  end

  def create
    @email_domain = EmailDomain.new(permitted_params)
    if @email_domain.save
        redirect_to email_domains_path, notice: t('flash.email_domain.create')
    else
      render :new
    end
  end

  def update
    @email_domain = EmailDomain.find(params[:id])
    if @email_domain.update(permitted_params)
      redirect_to email_domains_path, notice: t('flash.email_domain.update')
    else
      render :edit
    end
  end

  def destroy
    @email_domain.destroy
    redirect_to email_domains_path, notice: t('flash.email_domain.destroy')
  end
end
