class DnsRecordType < ActiveRecord::Base
  include SimplePosition
  default_scope { order(:position) }
end
