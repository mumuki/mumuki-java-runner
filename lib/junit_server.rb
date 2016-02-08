require 'mumukit'

Mumukit.configure do |config|
  config.docker_image = 'mumuki/mumuki-junit-worker'
  config.runner_name = 'junit-server'

end

require_relative './test_hook'