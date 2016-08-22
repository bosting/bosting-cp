class VhostAlias < ActiveRecord::Base
  belongs_to :vhost

  validates :name, presence: true, uniqueness: true
end
