class SystemGroup < ActiveRecord::Base
  validates :name, :gid, presence: true
  validates :name, :gid, uniqueness: true

  def self.find_nogroup
    @nogroup ||= SystemGroup.find_by(name: 'nogroup')
  end

  def self.find_webuser
    @webuser ||= SystemGroup.find_by(name: 'webuser')
  end
end
