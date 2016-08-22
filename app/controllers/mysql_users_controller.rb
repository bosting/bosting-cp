class MysqlUsersController < ApplicationController
  load_and_authorize_resource except: :create
  before_action :load_permitted_servers, only: [:new, :edit, :update]

  def index
    @mysql_users = @mysql_users.not_deleted
  end

  def new
    @mysql_user.create_db = true
  end

  def edit
  end

  def create
    authorize! :create, @mysql_user = MysqlUser.new(permitted_params)
    load_permitted_servers
    if @mysql_user.save
      redirect_to mysql_users_path, notice: t('flash.mysql_user.create')
    else
      render :new
    end
  end

  def update
    if @mysql_user.update(permitted_params)
      redirect_to mysql_users_path, notice: t('flash.mysql_user.update')
    else
      render :edit
    end
  end

  def destroy
    @mysql_user.destroy
    redirect_to mysql_users_path, notice: t('flash.mysql_user.destroy')
  end

  private
  def load_permitted_servers
    @apaches = if current_user.is_admin?
                 if @mysql_user.try(:apache).nil?
                   Apache.all
                 else
                   Apache.where(user_id: @mysql_user.apache.user_id)
                 end
               else
                 Apache.where(user_id: current_user.id)
               end.ordered
    @rails_servers = if current_user.is_admin?
                       if @mysql_user.try(:rails_server).nil?
                         RailsServer.all
                       else
                         RailsServer.where(user_id: @mysql_user.rails_server.user_id)
                       end
                     else
                       RailsServer.where(user_id: current_user.id)
                     end.ordered
  end
end
