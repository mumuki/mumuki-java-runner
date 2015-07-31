require 'mumukit'

class TestRunner < Mumukit::Stub
  include Mumukit::WithCommandLine

  def run_compilation!(dir)
    run_test_dir!(dir)
  ensure
    FileUtils.remove_entry_secure dir
  end

  def run_test_dir!(dir)
    run_command "javac #{dir.name}"
    run_command "java -jar .... #{dir.name}"
  end


end
