require 'mumukit/bridge'

describe 'Server' do
  let(:bridge) { Mumukit::Bridge::Bridge.new('http://localhost:4567') }

  before(:all) do
    @pid = Process.spawn 'rackup -p 4567', err: '/dev/null'
    sleep 3
  end
  after(:all) { Process.kill 'TERM', @pid }

  it 'answers a valid hash when submission passes' do
    response = bridge.run_tests!(test: %q{
public void testFoo() {
  Assert.assertEquals(Foo.bar(), 2);
}}, extra: '', content: %q{
class Foo {
  public static int bar() {
    return 1;
  }
}}, expectations: [])

    expect(response).to eq(status: :passed,
                           result: "```\n.\n\n```",
                           expectation_results: [],
                           test_results: [],
                           feedback: '',
                           response_type: :unstructured)
  end


  it 'answers a valid hash when submission fails' do
    response = bridge.run_tests!(test: %q{
public void testFoo() {
  Assert.assertEquals(Foo.bar(), 2);
}}, extra: '', content: %q{
class Foo {
  public static int bar() {
    return 2;
  }
}}, expectations: [])

    expect(response).to eq(status: :failed,
                           result: "```\n.\n\n```",
                           expectation_results: [],
                           test_results: [],
                           feedback: '',
                           response_type: :unstructured)
  end



end
