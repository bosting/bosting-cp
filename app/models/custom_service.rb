class CustomService < ActiveRecord::Base
  belongs_to :user

  validates :name, :month_price, :user, presence: true

  scope :active, -> { where(active: true) }
end
