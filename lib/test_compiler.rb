require 'tempfile'
require 'mumukit'

class TestCompiler < Mumukit::Stub
  def create_compilation!(request)
    dir = Dir.mktmpdir

    file = File.new(File.join(dir, 'SubmissionTest.java'))
    file.write(compile(request))
    file.close

    dir
  end

  def compile(request)
<<EOF
import java.util.*;

#{request.content}
#{request.extra}

public class SubmissionTest {
#{request.test}
}

EOF
  end
end
