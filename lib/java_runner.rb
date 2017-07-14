require 'mumukit'

Mumukit.runner_name = 'java'
Mumukit.configure do |config|
  config.docker_image = 'mumuki/mumuki-junit-worker'

end

require_relative './test_hook'
require_relative './metadata_hook'
