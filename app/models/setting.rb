class Setting < ActiveRecord::Base
  TYPES = { boolean: 1, integer: 2, string: 3 }
  default_scope { order(:name) }

  validates :name, presence: true, uniqueness: true
  validates :value, presence: true, if: Proc.new { |s| s.value != false }

  def self.get(name)
    return $settings[name] if $settings.key?(name)

    setting = Setting.find_by(name: name)
    if setting.value_type == TYPES[:boolean]
      !setting.value.to_i.zero?
    elsif setting.value_type == TYPES[:integer]
      setting.value.to_i
    else
      setting.value
    end
  end

  def self.panel_url
    (get('panel_ssl') ? 'https' : 'http') + '://' + get('panel_domain') + '/'
  end
end
