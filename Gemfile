source 'https://rubygems.org'

ruby '2.2.2', :engine => 'jruby', :engine_version => '9.0.0.0'

gem 'rake'

gem 'mumukit', github: 'mumuki/mumukit', branch: 'master'
gem 'mumukit-inspection', github: 'mumuki/mumukit-inspection', branch: 'master'

gem 'puma'

group :test do
  gem 'rspec', '2.13'
  gem 'mumukit-bridge', github: 'mumuki/mumukit-bridge', tag: 'v0.2.0'
end
