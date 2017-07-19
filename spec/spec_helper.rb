require_relative '../lib/java_runner'
require 'rspec'

def treq(content='', test='', extra='')
  OpenStruct.new(content: content, test: test, extra: extra)
end

