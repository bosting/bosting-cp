class ApacheDestructionsController < ApplicationController
  load_and_authorize_resource :apache
  load_and_authorize_resource :apache_destruction

  def new
    @apache_destruction.set_defaults
  end

  def create
    @apache.create_chef_task(:destroy)
    @apache_destruction.destroy_dependencies(@apache)
    @apache.destroy

    redirect_to apaches_path, flash: t('flash.apache_destruction.create')
  end
end
