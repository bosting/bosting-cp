class ApacheDestructionsController < ApplicationController
  load_and_authorize_resource :apache
  load_and_authorize_resource :apache_destruction

  def new
    @apache_destruction.set_defaults
  end

  def create
    @apache_destruction.destroy_dependencies(@apache)
    @apache.destroy
    @apache.create_chef_task(:destroy)

    redirect_to apaches_path, notice: t('flash.apache_destruction.create')
  end
end
