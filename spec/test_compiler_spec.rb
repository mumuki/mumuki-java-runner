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
class A {}

class B {}

public class SubmissionTest {
@Test
public void testTrue() {
  Assert.assertEquals(1, 1);
}
}
EOT

  describe '#compile' do
    let(:compiler) { TestCompiler.new(nil) }
    it { expect(compiler.compile(req(true_test, 'class A {}',  'class B {}'))).to eq(compiled_test_submission) }
  end

  describe '#create_compilation_file!' do
    let(:compiler) { TestCompiler.new(nil) }
    let(:file) { compiler.create_compilation!(req('@Test public void testFoo() { }', '', 'class A {}')) }

    it { expect(File.exists? file.path).to be true }
  end
end
