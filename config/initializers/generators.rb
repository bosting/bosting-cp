# Configure generators values
Rails.application.config.generators do |g|
  g.scaffold_controller :gauranga_controller
  g.show false
  g.stylesheets false
  g.test_framework :rspec, fixture: true
  g.fixture_replacement :factory_girl, dir: 'spec/factories'
  g.assets false
  g.helper false
  g.routing_specs false
  g.view_specs false
  g.helper_specs false
end
