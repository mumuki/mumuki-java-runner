require_relative 'spec_helper'

describe TestCompiler do
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
    let(:compiler) { TestCompiler.new(nil) }
    it { expect(compiler.compile(req(true_test, 'class B {}',  'class A {}'))).to eq(compiled_test_submission) }
  end

  describe '#create_compilation_file!' do
    let(:compiler) { TestCompiler.new(nil) }
    let(:dir) { compiler.create_compilation!(req('@Test public void testFoo() { }', '', 'class A {}')) }

    it { expect(File.exists? dir).to be true }
    it { expect(File.exists? "#{dir}/SubmissionTest.java").to be true }

    after { FileUtils.rm_rf(dir) }
  end
end
