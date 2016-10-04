class PgsqlDbsController < ApplicationController
  load_and_authorize_resource :pgsql_user
  load_and_authorize_resource :pgsql_db, through: :pgsql_user, except: :create

  def index
  end

  def new
  end

  def edit
  end

  def create
    authorize! :create, @pgsql_db = @pgsql_user.pgsql_dbs.build(permitted_params)
    if @pgsql_db.save
      @pgsql_db.create_chef_task(:create)
      redirect_to pgsql_user_pgsql_dbs_path, notice: t('flash.pgsql_db.create')
    else
      render :new
    end
  end

  def update
    @pgsql_db = PgsqlDb.find(params[:id])
    if @pgsql_db.update(permitted_params)
      @pgsql_db.create_chef_task(:create)
      redirect_to pgsql_user_pgsql_dbs_path, notice: t('flash.pgsql_db.update')
    else
      render :edit
    end
  end

  def destroy
    @pgsql_db.destroy
    @pgsql_db.create_chef_task(:create)
    redirect_to pgsql_user_pgsql_dbs_path, notice: t('flash.pgsql_db.destroy')
  end
end
