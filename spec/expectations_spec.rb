require_relative 'spec_helper'

describe JavaExpectationsHook do
  def req(expectations, content)
    struct expectations: expectations, content: content
  end

  def compile_and_run(request)
    runner.run!(runner.compile(request))
  end

  let(:runner) { JavaExpectationsHook.new }
  let(:result) { compile_and_run(req(expectations, code)) }

  context 'smells' do
    let(:code) { 'class X {}' }
    let(:expectations) { [] }

    it { expect(result).to eq [{expectation: {binding: 'X', inspection: 'HasTooShortIdentifiers'}, result: false}] }
  end

  context 'expectations' do
    describe 'DeclaresClass' do
      let(:code) { 'class Pepita {}' }
      let(:declares_foo) { {binding: '*', inspection: 'DeclaresClass:Foo'} }
      let(:declares_pepita) { {binding: '*', inspection: 'DeclaresClass:Pepita'} }
      let(:expectations) { [declares_foo, declares_pepita] }

      it { expect(result).to eq [{expectation: declares_foo, result: false}, {expectation: declares_pepita, result: true}] }
    end

    describe 'DeclaresMethod' do
      let(:code) { 'class Pepita { public void canta() {}}' }
      let(:declares_methods) { {binding: '*', inspection: 'DeclaresMethod'} }
      let(:declares_canta) { {binding: '*', inspection: 'DeclaresMethod:canta'} }
      let(:pepita_declares_canta) { {binding: 'Pepita', inspection: 'DeclaresMethod:canta'} }
      let(:pepita_declares_vola) { {binding: 'Pepita', inspection: 'DeclaresMethod:vola'} }
      let(:expectations) { [declares_methods, declares_canta, pepita_declares_canta, pepita_declares_vola] }

      it { expect(result).to eq [
                                    {expectation: declares_methods, result: true},
                                    {expectation: declares_canta, result: true},
                                    {expectation: pepita_declares_canta, result: true},
                                    {expectation: pepita_declares_vola, result: false}] }
    end

    describe 'UsesLambda' do
      let(:code) { 'class Main { public static void main(String[] args) { Arrays.asList("foo").stream().map((string) -> string);}}' }
      let(:uses_lambda) { {binding: '*', inspection: 'UsesLambda'} }
      let(:expectations) { [uses_lambda] }

      it { expect(result).to eq [{expectation: uses_lambda, result: true}] }
    end

    describe 'Uses' do
      let(:code) { '
        class Foo { public void m() {}};
        class Bar { public void m() {this.g();}  public void g() {return;} };' }
      let(:foo_delegates) { {binding: 'Foo', inspection: 'Delegates'} }
      let(:foo_m_delegates) { {binding: 'Intransitive:Foo.m', inspection: 'Delegates'} }
      let(:bar_m_delegates) { {binding: 'Intransitive:Bar.m', inspection: 'Delegates'} }
      let(:expectations) { [foo_delegates, foo_m_delegates, bar_m_delegates, {binding: '*', inspection: 'Except:HasTooShortIdentifiers'}] }

      it { expect(result).to eq [{expectation: foo_delegates, result: false},
                                 {expectation: foo_m_delegates, result: false},
                                 {expectation: bar_m_delegates, result: true}] }
    end

    describe 'Assigns' do
      let(:code) { 'class Main { public static void main(String[] args) { Object pepita = new Object();}}' }
      let(:assigns_foo) { {binding: '*', inspection: 'Assigns:foo'} }
      let(:assigns_pepita) { {binding: '*', inspection: 'Assigns:pepita'} }
      let(:expectations) { [assigns_foo, assigns_pepita] }

      it { expect(result).to eq [{expectation: assigns_foo, result: false}, {expectation: assigns_pepita, result: true}] }
    end

    describe 'Declares Superclass' do
      let(:code) { '
        class Bar extends Foo { public void method() {}};' }
      let(:inherits_foo) { {binding: 'Bar', inspection: 'DeclaresSuperclass:Foo'} }
      let(:inherits_bar) { {binding: 'Foo', inspection: 'DeclaresSuperclass:Bar'} }
      let(:expectations) { [inherits_foo, inherits_bar] }

      it { expect(result).to eq [{expectation: inherits_foo, result: true}, {expectation: inherits_bar, result: false}] }
    end

    describe 'Implements' do
      let(:code) { '
        class Bar implements Foo { public void method() {}};' }
      let(:implements_foo) { {binding: 'Bar', inspection: 'Implements:Foo'} }
      let(:implements_baz) { {binding: 'Bar', inspection: 'Implements:Baz'} }
      let(:expectations) { [implements_foo, implements_baz] }

      it { expect(result).to eq [{expectation: implements_foo, result: true}, {expectation: implements_baz, result: false}] }
    end

    describe 'Declares Enumeration' do
      let(:code) { '
        enum Bar { A,B,C }' }
      let(:enumeration_bar) { {binding: '*', inspection: 'DeclaresEnumaration:Bar'} }
      let(:enumeration_foo) { {binding: '*', inspection: 'DeclaresEnumeration:Foo'} }
      let(:expectations) { [enumeration_bar, enumeration_foo] }

      it { expect(result).to eq [{expectation: enumeration_bar, result: true}, {expectation: enumeration_foo, result: false}] }
    end
  end

end
