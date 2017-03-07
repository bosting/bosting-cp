class FtpsController < ApplicationController
  load_and_authorize_resource except: :create
  before_action :load_permitted_system_users, only: [:new, :create, :edit, :update]

  def index
  end

  def new
  end

  def edit
  end

  def create
    authorize! :create, @ftp = Ftp.new(permitted_params)
    if @ftp.save
      redirect_to ftps_path, notice: t('flash.ftp.create')
    else
      render :new
    end
  end

  def update
    if @ftp.update(permitted_params)
      redirect_to ftps_path, notice: t('flash.ftp.update')
    else
      render :edit
    end
  end

  def destroy
    @ftp.destroy
    redirect_to ftps_path, notice: t('flash.ftp.destroy')
  end

  private

  def load_permitted_system_users
    @system_users = if current_user.is_admin?
                      if %w(new create).include?(params[:action])
                        SystemUser.all
                      else
                        SystemUser.where(user_id: @ftp.system_user.user_id)
                      end
                    else
                      SystemUser.where(user_id: current_user.id)
                    end
  end
end
