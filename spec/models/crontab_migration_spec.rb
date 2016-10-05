require 'spec_helper'

describe CrontabMigration do
  describe 'JSON for Chef' do
    specify 'create action' do
      crontab_migration = CrontabMigration.new('user', 'apache22_php55', 'apache22_php56')
      expect(JSON.parse(crontab_migration.to_chef_json(:move))).to(
          match_json_expression(
              {
                  "user":"user",
                  "source_jail":"apache22_php55",
                  "destination_jail":"apache22_php56",
                  "type":"crontab_migration",
                  "action":"move"
              }
          )
      )
    end
  end
end
