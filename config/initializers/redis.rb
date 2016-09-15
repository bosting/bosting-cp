$redis = Redis.new(Rails.env.test? ? {} : {driver: :hiredis})
