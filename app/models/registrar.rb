class Registrar < ActiveRecord::Base
  validates :name, presence: true
end
