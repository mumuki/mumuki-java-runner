class JavaTestHook < Mumukit::Templates::FileHook
  # // TODO: Use MultiFileHook
  COMPILATION_ERROR_FLAG = '!!TEST FINISHED WITH COMPILATION ERROR!!'
  isolated true
  structured true, separator: '!!!JAVA-MUMUKI-OUTPUT!!!'

  def tempfile_extension
    '.java'
  end

  def command_line(filename)
    "runjunit #{filename}"
  end

  def to_structured_result(result)
    transform(JSON.parse(result))
  end

  def transform(examples)
    examples.map { |e| [e[0], e[1].to_sym, e[2].try {|result| Mumukit::ContentType::Markdown.code result}] }
  end

  def post_process_file(file, result, status)
    if result.include? COMPILATION_ERROR_FLAG
      [format_errored_result(result), :errored]
    else
      super
    end
  end

  def format_errored_result(result)
    Mumukit::ContentType::Markdown.highlighted_code :java, result.gsub(COMPILATION_ERROR_FLAG, '').gsub(/\/tmp\/tmp.*\/SubmissionTest/, "/tmp/SubmissionTest")
  end

  def compile_file_content(request)
    test = <<EOF
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
#{single_file?(request) ? request.content : ''}
#{request.extra}

public class SubmissionTest {
  #{request.test}
  @AfterClass
  public static void afterAll(){
      System.out.println("!!!JAVA-MUMUKI-OUTPUT!!!");
  }

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
    JSON.generate(files_of(request).merge({ "SubmissionTest.java" => test }))
  end

  def single_file?(request)
    files_of(request).empty?
  end
end
