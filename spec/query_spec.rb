require_relative './spec_helper'
require 'ostruct'

describe JavaQueryHook do
  let(:hook) { JavaQueryHook.new(nil) }
  let(:file) { hook.compile(request) }
  let(:result) { hook.run!(file) }


  context 'just literal expression' do
    let(:request) { struct(query: '5') }
    it { expect(result[0]).to eq "=> 5\n" }
  end

  context 'just query' do
    let(:request) { struct(query: '1 + 3') }
    it { expect(result[0]).to eq "=> 4\n" }
  end

  context 'query that uses content' do
    let(:request) { struct(query: 'new Foo().foo()', content: 'class Foo { int foo(){ return 1; } }') }
    it { expect(result[0]).to eq "=> 1\n" }
  end

  context 'query that uses content that throws an exception' do
    let(:request) { struct(query: 'new Foo().foo()', content: 'class Foo { int foo(){ throw new RuntimeException("ups"); } }') }
    it { expect(result[0]).to eq "Exception in thread \"main\" java.lang.RuntimeException: ups\n\tat Foo.foo(Query.java:7)\n\tat Query.main(Query.java:12)\n" }
    it { expect(result[1]).to eq :failed }
  end

  context 'query that throws an exception' do
    let(:request) { struct(query: 'throw new RuntimeException("ups")') }
    it { expect(result[0]).to eq "ups\n" }
    it { expect(result[1]).to eq :failed }
  end

  context 'query that uses content that does not compile' do
    let(:request) { struct(query: 'new Foo().foo()', content: 'class Foo { int foo() throw new RuntimeException("ups"); } }') }
    it { expect(result[0]).to eq "ups\n" }
    it { expect(result[1]).to eq :errored }
  end

  context 'query that does not compile' do
    let(:request) { struct(query: 'new Foo(foo()') }
    it { expect(result[0]).to eq "ups\n" }
    it { expect(result[1]).to eq :errored }
  end

  context 'query that is an expression' do
    let(:request) { struct(query: 'int x = 5;') }
    it { expect(result[0]).to eq "ups\n" }
    it { expect(result[1]).to eq :errored }
  end

end
