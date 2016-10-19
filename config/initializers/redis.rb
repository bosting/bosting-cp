options = {}
options[:driver] = :hiredis unless Rails.env.test?
options[:password] = Rails.application.secrets.redis_password if Rails.env.production?
$redis = Redis.new(options)
