class SystemGroup < ActiveRecord::Base
  validates :name, :gid, presence: true
  validates :name, :gid, uniqueness: true
end
