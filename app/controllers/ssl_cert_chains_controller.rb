class SslCertChainsController < ApplicationController
  load_and_authorize_resource except: :create

  def index
  end

  def new
  end

  def edit
  end

  def create
    @ssl_cert_chain = SslCertChain.new(permitted_params)
    if @ssl_cert_chain.save
        redirect_to ssl_cert_chains_path, notice: t('flash.ssl_cert_chain.create')
    else
      render :new
    end
  end

  def update
    @ssl_cert_chain = SslCertChain.find(params[:id])
    if @ssl_cert_chain.update(permitted_params)
      redirect_to ssl_cert_chains_path, notice: t('flash.ssl_cert_chain.update')
    else
      render :edit
    end
  end

  def destroy
    @ssl_cert_chain.destroy
    redirect_to ssl_cert_chains_path, notice: t('flash.ssl_cert_chain.destroy')
  end
end
