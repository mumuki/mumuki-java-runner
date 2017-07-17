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

class Foo {
  public int getAnInt() {
    return 3;
  }
}

public class SubmissionTest {
  @Test
  public void testGetAnInt() {
    Assert.assertEquals(3, new Foo().getAnInt());
  }
   public static void main(String[] args) {
     JUnitCore runner = new JUnitCore();
     runner.addListener(new MuListener());
     runner.run(SubmissionTest.class);;
   }
}
class MuListener extends RunListener {
  private Map<String, Collection<String>> tests = new HashMap<String, Collection<String>>();
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
    System.out.println(result);
  }

  public String prettyFormat(Collection<String> list) {
    StringJoiner joiner = new StringJoiner(",");
    String result = "[";
    for(String string : list) {
      joiner.add(prettyFormat(string));
    }
    result += joiner.toString();
    result += "]";
    return result;
  }
  public String prettyFormat(String string) {
    return "\"" + string + "\"";
  }
  public String prettyFormatResults(Collection<Collection<String>> list) {
    return "[" + prettyFormat(list.iterator().next()) + "]";
  }
}
