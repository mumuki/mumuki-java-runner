require 'mumukit'

class TestRunner < Mumukit::Stub
  include Mumukit::WithCommandLine

  def run_compilation!(dir)
    run_test_dir!(dir)
  ensure
    FileUtils.remove_entry_secure dir
  end

  def run_test_dir!(dir)
    command = "#{javac_command} -cp #{java_classpath} #{dir}/SubmissionTest.java"
    puts command
    compilation_out = run_command command
    return compilation_out if compilation_out[1] != :passed

    run_command "cd #{dir} && #{java_command} -cp #{java_classpath}:. SubmissionTest"
  end

  def javac_command
    config['javac_command']
  end

  def java_command
    config['java_command']
  end

  def java_classpath
    config['java_classpath']
  end
end
