require 'mumukit'

class TestRunner < Mumukit::Stub
  include Mumukit::WithCommandLine

  def run_compilation!(dir)
    run_test_dir!(dir)
  ensure
    FileUtils.remove_entry_secure dir
  end

  def run_test_dir!(dir)
    compilation_out = run_command "#{javac_command} -cp \"#{java_classpath}\" #{dir}/SubmissionTest.java 2>&1"
    return compilation_out if compilation_out[1] != :passed

    run_command "#{java_command} -cp \"#{java_classpath}:#{dir}\" SubmissionTest"
  end
end
