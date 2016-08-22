class EmailAliasesController < ApplicationController
  load_and_authorize_resource :email_domain
  load_and_authorize_resource :email_alias, through: :email_domain, except: :create

  def index
  end

  def new
  end

  def edit
  end

  def create
    authorize! :create, @email_alias = @email_domain.email_aliases.build(permitted_params)
    if @email_alias.save
        redirect_to email_domain_email_aliases_path(@email_domain), notice: t('flash.email_alias.create')
    else
      render :new
    end
  end

  def update
    @email_alias = EmailAlias.find(params[:id])
    if @email_alias.update(permitted_params)
      redirect_to email_domain_email_aliases_path(@email_domain), notice: t('flash.email_alias.update')
    else
      render :edit
    end
  end

  def destroy
    @email_alias.destroy
    redirect_to email_domain_email_aliases_path(@email_domain), notice: t('flash.email_alias.destroy')
  end
end
