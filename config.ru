require 'i18n'
require 'mumukit'

I18n.load_path += Dir[File.join('.', 'locales', '*.yml')]

require_relative 'lib/junit_server'

run Mumukit::Server::App