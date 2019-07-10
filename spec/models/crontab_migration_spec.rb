require 'spec_helper'

describe CrontabMigration do
  describe '#to_chef' do
    specify 'create action' do
      crontab_migration = CrontabMigration.new('user', 'apache22_php55', 'apache22_php56')
      expect(crontab_migration.to_chef(:move)).to(
        match(
          user: 'user',
          source_jail: 'apache22_php55',
          destination_jail: 'apache22_php56',
          type: 'crontab_migration',
          action: 'move'
        )
      )
    end
  end
end
