require 'mumukit'

class TestRunner < Mumukit::Stub
  include Mumukit::WithCommandLine

  def run_compilation!(dir)
    run_test_dir!(dir)
  ensure
    FileUtils.remove_entry_secure dir
  end

  def run_test_dir!(dir)
    compilation_out = run_command "#{javac_command} #{dir}/mumukit/SubmissionTest.java"
    return compilation_out if compilation_out[1] != :passed

    run_command "cd #{dir} && #{java_command} SubmissionTest"
  end

  def javac_command
    config['javac_command']
  end

  def java_command
    config['java_command']
  end
end
