require 'spec_helper'

describe QuickRegistration do
  before do
    create_system_user_shells
    create_system_groups
    create_ip_addresses
    create_dns_record_types
    create_apache_variations
    create_settings
  end

  it 'should be valid' do
    expect(build(:quick_registration)).to be_valid
  end

  it 'should be valid with user' do
    expect(build(:quick_registration_with_user)).to be_valid
  end

  it 'should not be valid without email' do
    expect(build(:quick_registration, email: nil)).not_to be_valid
  end

  describe 'top domain extraction' do
    context 'simple domain' do
      it 'should extract 2 level' do
        qr = QuickRegistration.new(domain: 'example.com')
        qr.send(:extract_top_domain)
        expect(qr.instance_variable_get(:@top_domain)).to eq('example.com')
        expect(qr.instance_variable_get(:@sub_domain)).to be_blank
      end

      it 'should extract 3 level' do
        qr = QuickRegistration.new(domain: 'sub.example.com')
        qr.send(:extract_top_domain)
        expect(qr.instance_variable_get(:@top_domain)).to eq('example.com')
        expect(qr.instance_variable_get(:@sub_domain)).to eq('sub')
      end

      it 'should extract 4 level' do
        qr = QuickRegistration.new(domain: 'bus.sub.example.com')
        qr.send(:extract_top_domain)
        expect(qr.instance_variable_get(:@top_domain)).to eq('example.com')
        expect(qr.instance_variable_get(:@sub_domain)).to eq('bus.sub')
      end
    end

    context 'complex domain' do
      it 'should extract 2 level' do
        qr = QuickRegistration.new(domain: 'example.com.ru')
        qr.send(:extract_top_domain)
        expect(qr.instance_variable_get(:@top_domain)).to eq('example.com.ru')
        expect(qr.instance_variable_get(:@sub_domain)).to be_blank
      end

      it 'should extract 3 level' do
        qr = QuickRegistration.new(domain: 'sub.example.com.ru')
        qr.send(:extract_top_domain)
        expect(qr.instance_variable_get(:@top_domain)).to eq('example.com.ru')
        expect(qr.instance_variable_get(:@sub_domain)).to eq('sub')
      end

      it 'should extract 4 level' do
        qr = QuickRegistration.new(domain: 'bus.sub.example.com.ru')
        qr.send(:extract_top_domain)
        expect(qr.instance_variable_get(:@top_domain)).to eq('example.com.ru')
        expect(qr.instance_variable_get(:@sub_domain)).to eq('bus.sub')
      end
    end

    context 'unknown domains' do
      it 'should extract 2 level' do
        qr = QuickRegistration.new(domain: 'example.test')
        qr.send(:extract_top_domain)
        expect(qr.instance_variable_get(:@top_domain)).to eq('example.test')
        expect(qr.instance_variable_get(:@sub_domain)).to be_blank
      end

      it 'should extract 3 level' do
        qr = QuickRegistration.new(domain: 'sub.example.test')
        qr.send(:extract_top_domain)
        expect(qr.instance_variable_get(:@top_domain)).to eq('example.test')
        expect(qr.instance_variable_get(:@sub_domain)).to eq('sub')
      end

      it 'should extract 4 level' do
        qr = QuickRegistration.new(domain: 'bus.sub.example.test')
        qr.send(:extract_top_domain)
        expect(qr.instance_variable_get(:@top_domain)).to eq('example.test')
        expect(qr.instance_variable_get(:@sub_domain)).to eq('bus.sub')
      end
    end
  end

  describe 'registration process' do
    subject do
      lambda do
        build(:quick_registration, domain: 'example.com')
          .process_registration
      end
    end

    it 'should create a user' do
      expect(subject).to change(User, :count).by(1)
    end

    it 'should create a system user' do
      expect(subject).to change(SystemUser, :count).by(1)
    end

    it 'should create a domain' do
      expect(subject).to change(Domain, :count).by(1)
    end

    it 'should create an origin and www dns records' do
      expect(subject).to change(DnsRecord, :count).by(2)
    end

    it 'should create an apache' do
      expect(subject).to change(Apache, :count).by(1)
    end

    it 'should create a vhost' do
      expect(subject).to change(Vhost, :count).by(1)
    end

    it 'should create a vhost alias' do
      expect(subject).to change(VhostAlias, :count).by(1)
    end

    it 'should not create an ftp' do
      expect(subject).to change(Ftp, :count).by(0)
    end

    it 'should not create a mysql user' do
      expect(subject).to change(MysqlUser, :count).by(0)
    end

    it 'should not create a mysql db' do
      expect(subject).to change(MysqlDb, :count).by(0)
    end

    it 'should not create a pgsql user' do
      expect(subject).to change(PgsqlUser, :count).by(0)
    end

    it 'should not create a pgsql db' do
      expect(subject).to change(PgsqlDb, :count).by(0)
    end

    it 'should send an email' do
      expect(subject).to change(ActionMailer::Base.deliveries, :size).by(1)
    end

    it 'should add a correct domain and dns record' do
      subject.call
      domain = Domain.last
      expect(domain.name).to eq('example.com')
      expect(domain.dns_records.map(&:origin).sort).to match_array(%w(@ www))
    end
  end

  describe 'uniqueness' do
    context '2nd level domain' do
      subject { build(:quick_registration, domain: 'example.com') }

      it 'should not be valid if domain exists' do
        create(:domain, name: 'example.com', dns_records:
          [build(:dns_record, origin: '@')])
        should_not be_valid
      end

      it 'should not be valid if vhost exists' do
        create(:vhost, server_name: 'example.com')
        should_not be_valid
      end

      it 'should not be valid if vhost alias exists' do
        create(:vhost_alias, name: 'example.com')
        should_not be_valid
      end
    end

    context '3rd level domain' do
      subject { build(:quick_registration, domain: 'subdomain.example.com') }

      it 'should not be valid if domain exists' do
        create(:domain, name: 'example.com', dns_records:
          [build(:dns_record, origin: 'subdomain')])
        should_not be_valid
      end

      it 'should not be valid if vhost exists' do
        create(:vhost, server_name: 'subdomain.example.com')
        should_not be_valid
      end

      it 'should not be valid if vhost alias exists' do
        create(:vhost_alias, name: 'subdomain.example.com')
        should_not be_valid
      end
    end
  end

  describe 'MySQL' do
    subject do
      lambda do
        build(:quick_registration, with_mysql: true).process_registration
      end
    end

    it('should create a mysql user') do
      should change(MysqlUser, :count).by(1)
    end
    it('should create a mysql db') do
      should change(MysqlDb, :count).by(1)
    end
  end

  describe 'PgSQL' do
    subject do
      lambda do
        build(:quick_registration, with_pgsql: true).process_registration
      end
    end

    it('should create a pgsql user') { should change(PgsqlUser, :count).by(1) }
    it('should create a pgsql db') { should change(PgsqlDb, :count).by(1) }
  end

  it 'should create ftp' do
    expect do
      build(:quick_registration, with_ftp: true).process_registration
    end.to change(Ftp, :count).by(1)
  end

  it 'should not create a new user' do
    user = create(:user)
    expect do
      build(:quick_registration, user: user.id).process_registration
    end.to change(User, :count).by(0)
  end

  describe '3rd level domain' do
    subject do
      lambda do
        build(:quick_registration, domain: 'subdomain.example.com')
          .process_registration
      end
    end

    it('should add a domain') { should change(Domain, :count).by(1) }
    it('should add one dns record') { should change(DnsRecord, :count).by(1) }
    it('should add a vhost') { should change(Vhost, :count).by(1) }
    it('should not add a www alias') { should change(VhostAlias, :count).by(0) }

    it 'should add a correct domain and dns record' do
      subject.call
      domain = Domain.last
      expect(domain.name).to eq('example.com')
      expect(domain.dns_records.map(&:origin).sort)
        .to match_array(%w(subdomain))
    end
  end

  describe '3rd level domain with existing domain' do
    subject do
      lambda do
        build(:quick_registration, domain: 'subdomain.example.com')
          .process_registration
      end
    end
    before(:each) { create(:domain, name: 'example.com') }

    it('should not add a domain') { should change(Domain, :count).by(0) }
    it('should add one dns record') { should change(DnsRecord, :count).by(1) }
    it('should not add a vhost') { should change(Vhost, :count).by(1) }
    it('should add a subdomain alias') do
      should change(VhostAlias, :count).by(0)
    end

    it 'should add a correct dns record' do
      subject.call
      dns_record = DnsRecord.last
      expect(dns_record.domain).to eq(Domain.last)
      expect(dns_record.origin).to eq('subdomain')
    end
  end

  it 'should create apache' do
    build(:quick_registration).process_registration

    apache = Apache.last
    expect(apache.system_user).to eq(SystemUser.last)
    user = User.last
    expect(user.apaches).to match_array([apache])
  end
end
