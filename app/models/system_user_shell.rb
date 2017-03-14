class SystemUserShell < ActiveRecord::Base
  validates :name, :path, presence: true

  def self.default_shell
    where(is_default: true).first
  end

  def self.nologin_shell
    where(name: 'nologin').first
  end
end
