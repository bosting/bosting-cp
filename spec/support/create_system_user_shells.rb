module CreateSystemUserShells
  def create_system_user_shells
    create(:system_user_shell, name: 'Bash', path: '/usr/local/bin/bash', is_default: true)
    create(:system_user_shell, name: 'nologin', path: '/usr/sbin/nologin')
  end
end

if defined?(RSpec)
  RSpec.configure { |config| config.include CreateSystemUserShells }
end
