require 'spec_helper'

describe QuickRegistration do
  before(:all) do
    create_system_user_shells
    create_system_groups
    create_ip_addresses
    create_dns_record_types
    create_apache_variations
  end
  after(:each) do
    User.where(is_admin: false).delete_all
    [SystemUser, Domain, DnsRecord, Apache, Vhost, VhostAlias, MysqlUser, MysqlDb, PgsqlUser, PgsqlDb, Ftp].each(&:delete_all)
  end

  it 'should be valid' do
    build(:quick_registration).should be_valid
  end

  it 'should be valid with user' do
    build(:quick_registration_with_user).should be_valid
  end

  it 'should not be valid without email' do
    build(:quick_registration, email: nil).should_not be_valid
  end

  describe 'top domain extraction' do
    context 'simple domain' do
      it 'should extract 2 level' do
        qr = QuickRegistration.new(domain: 'example.com')
        qr.send(:extract_top_domain)
        qr.top_domain.should == 'example.com'
        qr.sub_domain.should be_blank
      end

      it 'should extract 3 level' do
        qr = QuickRegistration.new(domain: 'sub.example.com')
        qr.send(:extract_top_domain)
        qr.top_domain.should == 'example.com'
        qr.sub_domain.should == 'sub'
      end

      it 'should extract 4 level' do
        qr = QuickRegistration.new(domain: 'bus.sub.example.com')
        qr.send(:extract_top_domain)
        qr.top_domain.should == 'example.com'
        qr.sub_domain.should == 'bus.sub'
      end
    end

    context 'complex domain' do
      it 'should extract 2 level' do
        qr = QuickRegistration.new(domain: 'example.com.ru')
        qr.send(:extract_top_domain)
        qr.top_domain.should == 'example.com.ru'
        qr.sub_domain.should be_blank
      end

      it 'should extract 3 level' do
        qr = QuickRegistration.new(domain: 'sub.example.com.ru')
        qr.send(:extract_top_domain)
        qr.top_domain.should == 'example.com.ru'
        qr.sub_domain.should == 'sub'
      end

      it 'should extract 4 level' do
        qr = QuickRegistration.new(domain: 'bus.sub.example.com.ru')
        qr.send(:extract_top_domain)
        qr.top_domain.should == 'example.com.ru'
        qr.sub_domain.should == 'bus.sub'
      end
    end

    context 'unknown domains' do
      it 'should extract 2 level' do
        qr = QuickRegistration.new(domain: 'example.test')
        qr.send(:extract_top_domain)
        qr.top_domain.should == 'example.test'
        qr.sub_domain.should be_blank
      end

      it 'should extract 3 level' do
        qr = QuickRegistration.new(domain: 'sub.example.test')
        qr.send(:extract_top_domain)
        qr.top_domain.should == 'example.test'
        qr.sub_domain.should == 'sub'
      end

      it 'should extract 4 level' do
        qr = QuickRegistration.new(domain: 'bus.sub.example.test')
        qr.send(:extract_top_domain)
        qr.top_domain.should == 'example.test'
        qr.sub_domain.should == 'bus.sub'
      end
    end
  end

  describe 'registration process' do
    subject { -> { build(:quick_registration, domain: 'example.com').process_registration } }

    it('should create a user') { should change(User, :count).by(1) }
    it('should create a system user') { should change(SystemUser, :count).by(1) }
    it('should create a domain') { should change(Domain, :count).by(1) }
    it('should create an origin and www dns records') { should change(DnsRecord, :count).by(2) }
    it('should create an apache') { should change(Apache, :count).by(1) }
    it('should create a vhost') { should change(Vhost, :count).by(1) }
    it('should create a vhost alias') { should change(VhostAlias, :count).by(1) }
    it('should not create an ftp') { should change(Ftp, :count).by(0) }
    it('should not create a mysql user') { should change(MysqlUser, :count).by(0) }
    it('should not create a mysql db') { should change(MysqlDb, :count).by(0) }
    it('should not create a pgsql user') { should change(PgsqlUser, :count).by(0) }
    it('should not create a pgsql db') { should change(PgsqlDb, :count).by(0) }
    it('should send an email') { should change(ActionMailer::Base.deliveries, :size).by(1) }

    it 'should add a correct domain and dns record' do
      subject.call
      domain = Domain.last
      domain.name.should == 'example.com'
      domain.dns_records.map(&:origin).sort.should == %w(@ www)
    end
  end

  describe 'uniqueness' do
    context '2nd level domain' do
      subject { build(:quick_registration, domain: 'example.com') }

      it 'should not be valid if domain exists' do
        create(:domain, name: 'example.com', dns_records: [build(:dns_record, origin: '@')])
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
        create(:domain, name: 'example.com', dns_records: [build(:dns_record, origin: 'subdomain')])
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
    subject { -> { build(:quick_registration, with_mysql: true).process_registration } }

    it('should create a mysql user') { should change(MysqlUser, :count).by(1) }
    it('should create a mysql db') { should change(MysqlDb, :count).by(1) }
  end

  describe 'PgSQL' do
    subject { -> { build(:quick_registration, with_pgsql: true).process_registration } }

    it('should create a pgsql user') { should change(PgsqlUser, :count).by(1) }
    it('should create a pgsql db') { should change(PgsqlDb, :count).by(1) }
  end

  it 'should create ftp' do
    expect {
      build(:quick_registration, with_ftp: true).process_registration
    }.to change(Ftp, :count).by(1)
  end

  it 'should not create a new user' do
    user = create(:user)
    expect {
      build(:quick_registration, user: user.id).process_registration
    }.to change(User, :count).by(0)
  end

  describe '3rd level domain' do
    subject { -> { build(:quick_registration, domain: 'subdomain.example.com').process_registration } }

    it('should add a domain') { should change(Domain, :count).by(1) }
    it('should add one dns record') { should change(DnsRecord, :count).by(1) }
    it('should add a vhost') { should change(Vhost, :count).by(1) }
    it('should not add a www alias') { should change(VhostAlias, :count).by(0) }

    it 'should add a correct domain and dns record' do
      subject.call
      domain = Domain.last
      domain.name.should == 'example.com'
      domain.dns_records.map(&:origin).sort.should == ['subdomain']
    end
  end

  describe '3rd level domain with existing domain' do
    subject { -> { build(:quick_registration, domain: 'subdomain.example.com').process_registration } }
    before(:each) { create(:domain, name: 'example.com') }

    it('should not add a domain') { should change(Domain, :count).by(0) }
    it('should add one dns record') { should change(DnsRecord, :count).by(1) }
    it('should not add a vhost') { should change(Vhost, :count).by(1) }
    it('should add a subdomain alias') { should change(VhostAlias, :count).by(0) }

    it 'should add a correct dns record' do
      subject.call
      dns_record = DnsRecord.last
      dns_record.domain.should == Domain.last
      dns_record.origin.should == 'subdomain'
    end
  end

  it 'should create apache' do
    build(:quick_registration).process_registration

    apache = Apache.last
    apache.system_user.should == SystemUser.last
    user = User.last
    user.apaches.should == [apache]
  end
end
