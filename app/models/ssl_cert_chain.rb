class SslCertChain < ActiveRecord::Base
  validates :name, :certificate, presence: true

  has_many :vhosts, dependent: :restrict_with_error
end
