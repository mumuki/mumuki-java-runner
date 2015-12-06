class TestRunner < Mumukit::FileTestRunner
  include Mumukit::WithIsolatedEnvironment

  def run_test_command(filename)
    "#{runjunit_command} #{filename}"
  end
end
