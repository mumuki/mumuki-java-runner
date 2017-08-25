class JavaTestHook < JavaFileHook
  structured true

  def command_line(filename)
    "runtest #{filename}"
  end

  def to_structured_result(result)
    transform(JSON.parse(result))
  end

  def transform(examples)
    examples.map { |e| [e[0], e[1].to_sym, e[2].try {|result| Mumukit::ContentType::Markdown.code result}] }
  end

  def compile_file_content(request)
    <<EOF
import java.util.*;
import java.util.function.*;
import java.util.stream.*;
import java.util.stream.Collectors.*;
import java.time.*;
import org.junit.runner.RunWith;
import org.junit.*;
import org.junit.runner.*;
import org.junit.runner.notification.*;
import org.junit.runners.*;
import org.junit.runners.model.InitializationError;
import org.apache.commons.text.StringEscapeUtils;
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
  private Map<String, Collection<String>> tests = new HashMap<>();
  @Override
  public void testStarted(Description description) throws Exception {
    String methodName = description.getMethodName();
    tests.put(methodName, Arrays.asList(methodName, "passed"));
  }

  @Override
  public void testFailure(Failure failure) {
    String methodName = failure.getDescription().getMethodName();
    tests.put(methodName, Arrays.asList(methodName, "failed", failure.getMessage()));
  }

  @Override
  public void testRunFinished(Result r) {
    String result = prettyFormatResults(tests.values());
    System.out.println(StringEscapeUtils.unescapeJson(result));
  }

  public String prettyFormatString(String string) {
    return ("\\\""+string+"\\\"");
  }
  public String prettyFormatExample(Collection<String> example) {
    return "["+example.stream().map(element -> prettyFormatString(element)).collect(Collectors.joining(",")) +"]";
  }
  public String prettyFormatResults(Collection<Collection<String>> results) {
    return "["+results.stream().map(element -> prettyFormatExample(element)).collect(Collectors.joining(","))+"]";
  }
}
EOF
  end

end
