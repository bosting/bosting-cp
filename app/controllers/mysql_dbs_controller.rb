class MysqlDbsController < ApplicationController
  load_and_authorize_resource :mysql_user
  load_and_authorize_resource :mysql_db, through: :mysql_user, except: :create

  def index
  end

  def new
  end

  def edit
  end

  def create
    authorize! :create, @mysql_db = @mysql_user.mysql_dbs.build(permitted_params)
    if @mysql_db.save
      @mysql_db.create_chef_task(:create)
      redirect_to mysql_user_mysql_dbs_path, notice: t('flash.mysql_db.create')
    else
      render :new
    end
  end

  def update
    if @mysql_db.update(permitted_params)
      @mysql_db.create_chef_task(:create)
      redirect_to mysql_user_mysql_dbs_path, notice: t('flash.mysql_db.update')
    else
      render :edit
    end
  end

  def destroy
    @mysql_db.destroy
    redirect_to mysql_user_mysql_dbs_path, notice: t('flash.mysql_db.destroy')
  end
end
