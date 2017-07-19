require_relative 'spec_helper'

def req(content, test='')
  struct content: content, test: test
end

describe JavaFeedbackHook do

  before {I18n.locale = :es}

  let(:server) {JavaTestHook.new}
  let!(:test_results) {server.run!(server.compile(request))}
  let(:feedback) {JavaFeedbackHook.new.run!(request, OpenStruct.new(test_results: test_results))}

  context 'missing semicolon' do
    let(:request) {req('class Foo {};', %q{
      public void testFoo(){
        Assert.assertEquals(2, 3)
      }
    })}

    it {expect(feedback).to include("* Parece que falta un ';' cerca de `Assert.assertEquals(2, 3)`")}
  end
end
