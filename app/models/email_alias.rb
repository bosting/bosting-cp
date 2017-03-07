class EmailAlias < ActiveRecord::Base
  include EmailCommon

  default_scope { where(hidden: false).order(:email) }

  def name
    username
  end
end
