class PgsqlUsersController < ApplicationController
  load_and_authorize_resource except: :create
  before_action :load_permitted_servers, only: [:new, :edit, :update]

  def index
    @pgsql_users = @pgsql_users.not_deleted
  end

  def new
    @pgsql_user.create_db = true
  end

  def edit
  end

  def create
    authorize! :create, @pgsql_user = PgsqlUser.new(permitted_params)
    load_permitted_servers
    if @pgsql_user.save
        redirect_to pgsql_users_path, notice: t('flash.pgsql_user.create')
    else
      render :new
    end
  end

  def update
    @pgsql_user = PgsqlUser.find(params[:id])
    if @pgsql_user.update(permitted_params)
      redirect_to pgsql_users_path, notice: t('flash.pgsql_user.update')
    else
      render :edit
    end
  end

  def destroy
    @pgsql_user.destroy
    redirect_to pgsql_users_path, notice: t('flash.pgsql_user.destroy')
  end

  private
  def load_permitted_servers
    @apaches = if current_user.is_admin?
                 if @pgsql_user.apache.nil?
                   Apache.all
                 else
                   Apache.where(user_id: @pgsql_user.apache.user_id)
                 end
               else
                 Apache.where(user_id: current_user.id)
               end.ordered
    @rails_servers = if current_user.is_admin?
                       if @pgsql_user.rails_server.nil?
                         RailsServer.all
                       else
                         RailsServer.where(user_id: @pgsql_user.rails_server.user_id)
                       end
                     else
                       RailsServer.where(user_id: current_user.id)
                     end.ordered
  end
end
