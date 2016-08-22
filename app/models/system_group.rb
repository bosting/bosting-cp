class SystemGroup < ActiveRecord::Base
  validates :name, :gid, presence: true
end
