module EmailCommon
  extend ActiveSupport::Concern

  included do
    belongs_to :email_domain
    before_save :fill_email
  end

  def fill_email
    self.email = "#{username}@#{email_domain.name}"
  end
end
