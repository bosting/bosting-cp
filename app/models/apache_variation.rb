class ApacheVariation < ActiveRecord::Base
  include SimplePosition
  default_scope { order(:position) }

  validates :name, :description, presence: true

  def self.get_default_id
    where(is_default: true).pluck(:id).first
  end

  def self.get_collection
    select([:id, :description]).map{ |av| [av.to_label, av.id] }
  end

  def to_label
    description
  end

  def prefix_path
    "/usr/jails/#{name}"
  end
end
