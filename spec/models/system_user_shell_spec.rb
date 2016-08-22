require 'spec_helper'

describe SystemUserShell do
  it 'should be valid' do
    expect(create(:system_user_shell)).to be_valid
  end
end
