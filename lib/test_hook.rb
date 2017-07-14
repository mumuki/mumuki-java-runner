class JavaTestHook < Mumukit::Templates::FileHook
  isolated true
  structured true

  def tempfile_extension
    '.java'
  end

  def command_line(filename)
    "runjunit #{filename}"
  end

  def to_structured_result(result)
    puts "\n\n\nRESULTADOSTR: #{result}\n\n\n"
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
import org.junit.runner.RunWith;
import org.junit.*;
import org.junit.runner.*;
import org.junit.runner.notification.*;
import org.junit.runners.*;
import org.junit.runners.model.InitializationError;

#{request.content}
#{request.extra}

public class SubmissionTest {
  #{request.test}
  public static void main(String[] args) {
    JUnitCore core = new JUnitCore();
    core.addListener(new MuListener());
    core.run(SubmissionTest.class);
  }
}
class MuListener extends RunListener {
  @Override
  public void testRunFinished(Result result) {
    String status = result.wasSuccessful() ? "success" : "failed";
    Map<String, String> results = new HashMap<String, String>();
    Map<String, String> tests = new HashMap<String, String>();
    tests.put("failures", String.valueOf(result.getFailureCount()));
    tests.put("status", status);
    tests.put("detailed", String.valueOf(result.getFailures()));
    results.put("tests", String.valueOf(tests));
    System.out.println(results.toString());
  }
}
EOF
  end

end
