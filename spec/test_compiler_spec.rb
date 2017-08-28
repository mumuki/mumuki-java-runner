require_relative 'spec_helper'

describe 'compilation' do
  def req(test, extra, content)
    OpenStruct.new(test:test, extra:extra, content: content)
  end

  true_test = <<EOT
@Test
  public void testTrue() {
    Assert.assertEquals(1, 1);
  }
EOT

  compiled_test_submission = <<EOT
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
class A {}
class B {}

public class SubmissionTest {
  @Test
  public void testTrue() {
    Assert.assertEquals(1, 1);
  }

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
    return ("\\""+string+"\\"");
  }
  public String prettyFormatExample(Collection<String> example) {
    return "["+example.stream().map(element -> prettyFormatString(element)).collect(Collectors.joining(",")) +"]";
  }
  public String prettyFormatResults(Collection<Collection<String>> results) {
    return "["+results.stream().map(element -> prettyFormatExample(element)).collect(Collectors.joining(","))+"]";
  }
}
EOT

  describe '#compile' do
    let(:compiler) { JavaTestHook.new(nil) }
    it { expect(compiler.compile_file_content(req(true_test, 'class B {}',  'class A {}'))).to eq(compiled_test_submission) }
  end
end
