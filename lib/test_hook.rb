class JavaTestHook < Mumukit::Templates::FileHook
  isolated true

  def tempfile_extension
    '.java'
  end

  def command_line(filename)
    "runjunit #{filename}"
  end

  def post_process_file(file, result, status)
    if result.include? '!!TEST FINISHED WITH COMPILATION ERROR!!'
      [result, :errored]
    else
      super
    end
  end

  def compile_file_content(request)
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