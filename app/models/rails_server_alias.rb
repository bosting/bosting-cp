class RailsServerAlias < ActiveRecord::Base
  belongs_to :rails_server

  validates :name, presence: true
end
