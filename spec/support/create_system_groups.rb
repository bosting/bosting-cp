module CreateSystemGroups
  def create_system_groups
    create(:system_group, name: 'webuser', gid: 8080)
    create(:system_group, name: 'nogroup', gid: 65533)
  end
end

if defined?(RSpec)
  RSpec.configure { |config| config.include CreateSystemGroups }
end
