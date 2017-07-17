require_relative 'spec_helper'

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

    context 'when test fails' do
      let(:content) do
        <<JAVA
class Foo {
  public int getAnInt() {
    return 2;
  }
}
JAVA
      end
      it { expect(results).to eq [['testGetAnInt', :failed, 'expected:<3> but was:<2>']] }

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

      it { expect(results).to eq [['testGetAnInt', :passed, nil], ["testGetACharacter", :passed, nil], ['testGetAFoo', :failed, 'expected:<3> but was:<4>']] }
    end
  end
end
