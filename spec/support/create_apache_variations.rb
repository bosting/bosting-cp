module CreateApacheVariations
  def create_apache_variations
    create(:apache_variation, name: 'Apache 2.2, PHP 5.3')
    create(:apache_variation, name: 'Apache 2.2, PHP 5.4')
  end
end

if defined?(RSpec)
  RSpec.configure { |config| config.include CreateApacheVariations }
end
