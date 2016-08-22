RSpec.configure do |config|
  config.before(:suite) do
    Timecop.travel(Time.local(2008, 9, 1, 10, 5, 0))
  end

  config.after(:suite) do
    Timecop.return
  end
end
