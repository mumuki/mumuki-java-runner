require 'tempfile'

class TestCompiler < Mumukit::FileTestCompiler
  def compile(request)
<<EOF
import java.util.*;
import java.util.function.*;
import java.util.stream.*;
import java.time.*;
import org.junit.*;

#{request.content}

#{request.extra}

public class SubmissionTest {
#{request.test}

public static void main(String args[]) {
  org.junit.runner.JUnitCore.main("SubmissionTest");
}
}
EOF
  end
end
