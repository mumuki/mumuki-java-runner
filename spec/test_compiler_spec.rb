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
import java.time.*;
import org.junit.*;

class A {}

class B {}

public class SubmissionTest {
@Test
public void testTrue() {
  Assert.assertEquals(1, 1);
}


public static void main(String args[]) {
  org.junit.runner.JUnitCore.main("SubmissionTest");
}
}
EOT

  describe '#compile' do
    let(:compiler) { TestHook.new(nil) }
    it { expect(compiler.compile_file_content(req(true_test, 'class B {}',  'class A {}'))).to eq(compiled_test_submission) }
  end
end
