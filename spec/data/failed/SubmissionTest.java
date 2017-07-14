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
    return 2;
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


