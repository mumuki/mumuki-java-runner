class TestRunner < Mumukit::FileTestRunner
  include Mumukit::WithIsolatedEnvironment

  def run_test_command(filename)
    "#{runjunit_command} #{filename}"
  end

  def post_process_file(file, result, status)
    if result.include? '!!TEST FINISHED WITH COMPILATION ERROR!!'
      [result, :errored]
    else
      super
    end
  end
end
