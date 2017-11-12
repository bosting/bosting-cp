# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum, this matches the default thread size of Active Record.
#
threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }.to_i
threads threads_count, threads_count

rails_env = ENV['RAILS_ENV'] || 'development'
environment rails_env

case rails_env
when 'production'
  daemonize
  bind 'unix://tmp/sockets/puma.sock'
  pidfile 'tmp/pids/puma.pid'
  state_path 'tmp/pids/puma.state'
  stdout_redirect 'log/puma.log', 'log/puma_error.log', true
else
  port ENV.fetch('PORT') { 3000 }
end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
