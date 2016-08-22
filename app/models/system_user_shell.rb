class SystemUserShell < ActiveRecord::Base
  validates :name, :path, presence: true

  def self.get_default_shell
    where(is_default: true).first
  end

  def self.get_nologin_shell
    where(name: 'nologin').first
  end
end
