class EditUsersController < ApplicationController
  load_and_authorize_resource except: :create

  def index
  end

  def new
  end

  def edit
  end

  def create
    authorize! :create, @edit_user = EditUser.new(permitted_params)
    if @edit_user.save
        redirect_to edit_users_path, notice: t('flash.user.create')
    else
      render :new
    end
  end

  def update
    if @edit_user.update(permitted_params)
      redirect_to edit_users_path, notice: t('flash.user.update')
    else
      render :edit
    end
  end

  def destroy
    @edit_user.destroy
    redirect_to edit_users_path, notice: t('flash.user.destroy')
  end
end
