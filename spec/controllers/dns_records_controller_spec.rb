require 'spec_helper'

describe DnsRecordsController do
  before(:all) do
    @domain = create(:domain)
    2.times { create(:dns_record, domain: @domain) }
  end
  render_views

  context 'as user' do
    login_user Domain

    it 'index action should render index template' do
      get :index, domain_id: @domain.id
      response.should render_template(:index)
    end

    it 'new action should render new template' do
      get :new, domain_id: @domain.id
      response.should render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      DnsRecord.any_instance.stubs(:valid?).returns(false)
      post :create, domain_id: @domain.id, dns_record: attributes_for(:dns_record)
      response.should render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      DnsRecord.any_instance.stubs(:valid?).returns(true)
      post :create, domain_id: @domain.id, dns_record: attributes_for(:dns_record)
      response.should redirect_to(domain_dns_records_path(@domain))
    end

    it 'edit action should render edit template' do
      get :edit, id: DnsRecord.first, domain_id: @domain.id
      response.should render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      DnsRecord.any_instance.stubs(:valid?).returns(false)
      put :update, id: DnsRecord.first, domain_id: @domain.id, dns_record: attributes_for(:dns_record)
      response.should render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      DnsRecord.any_instance.stubs(:valid?).returns(true)
      put :update, id: DnsRecord.first, domain_id: @domain.id, dns_record: attributes_for(:dns_record)
      response.should redirect_to(domain_dns_records_path(@domain))
    end

    it 'destroy action should destroy model and redirect to index action' do
      dns_record = DnsRecord.first
      delete :destroy, id: dns_record, domain_id: @domain.id
      response.should redirect_to(domain_dns_records_path(@domain))
      DnsRecord.exists?(dns_record.id).should be_falsey
    end
  end
end
