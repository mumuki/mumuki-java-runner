require_relative 'spec_helper'
def format(result)
  Mumukit::ContentType::Markdown.code result
end

describe 'running' do
  let(:runner) { JavaTestHook.new }

  describe '#run' do
    let(:file) { runner.compile(treq(content, test, extra)) }
    let(:raw_results) { runner.run!(file) }
    let(:results) { raw_results[0] }

    let(:extra) { '' }
    let(:content) { '' }
    let(:test) do
        <<JAVA
  @Test
  public void testGetAnInt() {
    Assert.assertEquals(3, new Foo().getAnInt());
  }
JAVA
      end

    context 'when test does not compile' do
      let(:content) do
        <<JAVA
class Foo {
  public int getAnInt() {
    return 3;
  }
JAVA
      end
      it { expect(results).to include 'error: reached end of file while parsing' }
    end

    context 'when test fails with int' do
      let(:content) do
        <<JAVA
class Foo {
  public int getAnInt() {
    return 2;
  }
}
JAVA
      end
          let(:test) do
        <<JAVA
  @Test
  public void testGetAnInt() {
    Assert.assertEquals(3, new Foo().getAnInt());
  }
JAVA
      end

      it { expect(results).to eq [['testGetAnInt', :failed, format('expected:<3> but was:<2>')]]}

    end
    context 'when test fails with array' do
      let(:content) do
        <<JAVA
class Baz {
  public List<String> getAnArray() {
    return Arrays.asList("foo");
  }
}
JAVA
      end
          let(:test) do
        <<JAVA
  @Test
  public void testGetAnArray() {
    Assert.assertEquals(Arrays.asList("bar"), new Baz().getAnArray());
  }
JAVA
      end

      it { expect(results).to eq [['testGetAnArray', :failed, format('expected:<[bar]> but was:<[foo]>')]]}
    end
    context 'when test fails with char' do
      let(:content) do
        <<JAVA
class Baz {
  public char getAChar() {
    return 'a';
  }
}
JAVA
      end
          let(:test) do
        <<JAVA
  @Test
  public void testGetAChar() {
    Assert.assertEquals('b', new Baz().getAChar());
  }
JAVA
      end

      it { expect(results).to eq [['testGetAChar', :failed, format('expected:<98> but was:<97>')]]}
    end
    context 'when test fails with String' do
      let(:content) do
        <<JAVA
class Baz {
  public String getAString() {
    return "foo";
  }
}
JAVA
      end
          let(:test) do
        <<JAVA
  @Test
  public void testGetAChar() {
    Assert.assertEquals("bar", new Baz().getAString());
  }
JAVA
      end

      it { expect(results).to eq [['testGetAChar', :failed, format('expected:<[bar]> but was:<[foo]>')]]}
    end

    context 'when test passes' do
          let(:test) do
        <<JAVA
  @Test
  public void testGetAnInt() {
    Assert.assertEquals(3, new Foo().getAnInt());
  }
  @Test
  public void testGetAFoo() {
    Assert.assertEquals(3, 4);
  }
  @Test
  public void testGetACharacter() {
    Assert.assertEquals('a', 'a');
  }

JAVA
      end

      let(:content) do
        <<JAVA
class Foo {
  public int getAnInt() {
    return 3;
  }
}
JAVA
      end

      it { expect(results).to eq [['testGetAnInt', :passed, nil], ["testGetACharacter", :passed, nil], ['testGetAFoo', :failed, format('expected:<3> but was:<4>')]] }
    end
  end
end
