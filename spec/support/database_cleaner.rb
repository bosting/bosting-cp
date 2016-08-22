DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean
  end

  config.after(:all) do
    DatabaseCleaner.clean
  end
end
