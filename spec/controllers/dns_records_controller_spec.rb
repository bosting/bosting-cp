require 'spec_helper'

describe DnsRecordsController do
  let!(:domain) { create(:domain) }
  let!(:dns_record) { create(:dns_record, domain: domain) }

  context 'as user' do
    login_user Domain

    it 'index action should render index template' do
      get :index, domain_id: domain.id
      expect(response).to render_template(:index)
    end

    it 'new action should render new template' do
      get :new, domain_id: domain.id
      expect(response).to render_template(:new)
    end

    it 'create action should render new template when model is invalid' do
      DnsRecord.any_instance.stubs(:valid?).returns(false)
      post :create, domain_id: domain.id, dns_record: attributes_for(:dns_record)
      expect(response).to render_template(:new)
    end

    it 'create action should redirect when model is valid' do
      DnsRecord.any_instance.stubs(:valid?).returns(true)
      post :create, domain_id: domain.id, dns_record: attributes_for(:dns_record)
      expect(response).to redirect_to(domain_dns_records_url(domain))
    end

    it 'edit action should render edit template' do
      get :edit, id: dns_record, domain_id: domain.id
      expect(response).to render_template(:edit)
    end

    it 'update action should render edit template when model is invalid' do
      DnsRecord.any_instance.stubs(:valid?).returns(false)
      put :update, id: dns_record, domain_id: domain.id, dns_record: attributes_for(:dns_record)
      expect(response).to render_template(:edit)
    end

    it 'update action should redirect when model is valid' do
      DnsRecord.any_instance.stubs(:valid?).returns(true)
      put :update, id: dns_record, domain_id: domain.id, dns_record: attributes_for(:dns_record)
      expect(response).to redirect_to(domain_dns_records_url(domain))
    end

    it 'destroy action should destroy model and redirect to index action' do
      delete :destroy, id: dns_record, domain_id: domain.id
      expect(response).to redirect_to(domain_dns_records_url(domain))
      DnsRecord.exists?(dns_record.id).should be_falsey
    end
  end
end
