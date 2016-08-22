class SettingsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def edit
  end

  def update
    @setting = Setting.find(params[:id])
    if @setting.update(permitted_params)
      redirect_to settings_path, notice: t('flash.setting.update')
    else
      render :edit
    end
  end
end
