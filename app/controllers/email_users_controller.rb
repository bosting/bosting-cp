class EmailUsersController < ApplicationController
  load_and_authorize_resource :email_domain
  load_and_authorize_resource :email_user, through: :email_domain, except: :create

  def index
  end

  def new
  end

  def edit
  end

  def create
    authorize! :create, @email_user = @email_domain.email_users.build(permitted_params)
    if @email_user.save
        redirect_to email_domain_email_users_path(@email_domain), notice: t('flash.email_user.create')
    else
      render :new
    end
  end

  def update
    @email_user = EmailUser.find(params[:id])
    if @email_user.update(permitted_params)
      redirect_to email_domain_email_users_path(@email_domain), notice: t('flash.email_user.update')
    else
      render :edit
    end
  end

  def destroy
    @email_user.destroy
    redirect_to email_domain_email_users_path(@email_domain), notice: t('flash.email_user.destroy')
  end
end
