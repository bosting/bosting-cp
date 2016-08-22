class AddDescriptionToApacheVariations < ActiveRecord::Migration
  def up
    add_column :apache_variations, :description, :string
    ApacheVariation.reset_column_information
    ApacheVariation.all.each do |av|
      av.description = av.name
      av.name = av.attributes['prefix_path'].sub(%r{^/usr/local/}, '')
      av.save!
    end
  end

  def down
    remove_column :apache_variations, :description
  end
end
