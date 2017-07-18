require 'active_support/all'
require 'mumukit/bridge'

describe 'Server' do
  let(:bridge) { Mumukit::Bridge::Runner.new('http://localhost:4568') }

  before(:all) do
    @pid = Process.spawn 'rackup -p 4568', err: '/dev/null'
    sleep 8
  end
  after(:all) { Process.kill 'TERM', @pid }

  it 'answers a valid hash when submission passes' do
    response = bridge.run_tests!(test: %q{
@Test
public void testFoo() {
  Assert.assertEquals(Foo.bar(), 2);
}}, extra: '', content: %q{
class Foo {
  public static int bar() {
    return 2;
  }
}}, expectations: [])

    expect(response).to eq(response_type: :structured,
                           test_results: [{title: 'testTestFoo', status: :passed, result: ''}],
                           status: :passed,
                           feedback: '',
                           expectation_results: [],
                           result: '')
  end


  it 'answers a valid hash when submission fails' do
    response = bridge.run_tests!(test: %q{
public void testFoo() {
  Assert.assertEquals(Foo.bar(), 2);
}}, extra: '', content: %q{
class Foo {
  public static int bar() {
    return 1;
  }
}}, expectations: [])

    expect(response[:result]).to eq(response_type: :structured,
                           test_results: [{title: 'testTestFoo', status: :failed, result: ''}],
                           status: :passed,
                           feedback: '',
                           expectation_results: [],
                           result: '')
  end


end
