require 'spec_helper'

RSpec.describe SslCertChain, type: :model do
  it 'should be valid' do
    build(:ssl_cert_chain).should be_valid
  end
end
