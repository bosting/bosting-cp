class RailsServer < ActiveRecord::Base
  belongs_to :user
  has_many :rails_server_aliases, dependent: :delete_all

  validates :name, :hostname, :user_id, presence: true

  accepts_nested_attributes_for :rails_server_aliases, allow_destroy: true

  scope :ordered, -> { order('`name` ASC') }
end
