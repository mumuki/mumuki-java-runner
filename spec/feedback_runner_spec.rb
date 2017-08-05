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

  context 'missing parenthesis' do
    let(:request) {req('class Foo {};', %q{
      public void testFoo){
        Assert.assertEquals(2, 3);
      }
    })}

    it {expect(feedback).to include("* Parece que falta un '(' cerca de `public void testFoo){`")}
  end

  context 'missing bracket' do
    let(:request) {req('class Foo() {};', %q{
      public void testFoo()){
        Assert.assertEquals(2, 3);
      }
    })}

    it {expect(feedback).to include("* Se esperaba una { cerca de `class Foo() {};`. Fijate si tal vez, introdujiste un paréntesis de más o está mal escrita la declaración de clase o método.")}
  end

  context 'missing method declaration' do
    let(:request) {req('class Foo {};', %q{
      public void testFoo(){
        Assert.assertEquals(2, new Foo().getAnInt());
      }
    })}

    it {expect(feedback).to include("* No se encontró la definición de `method getAnInt()` en `class Foo`")}
  end
  context 'missing return statement' do
    let(:request) {req(%q{
    class Foo {
      public int getAnInt() {
        int foo = 1 + 2;
      }
    }}, %q{
      public void testFoo(){
        Assert.assertEquals(2, new Foo().getAnInt());
      }
    })}

    it {expect(feedback).to include("Hay un método que debería retornar algo, pero no está retornando nada. ¡Revisá bien tu código!")}
  end
  context 'missing return statement' do
    let(:request) {req(%q{
    class Foo {
      public int getAnInt() {
        return 2;
      }
    }
    interface Bar {
      public int getAnInt();
    }
    class Baz {
      Bar bar = new Foo();
    }}, %q{
      public void testFoo(){
        Assert.assertEquals(2, new Foo().getAnInt());
      }
    })}

    it {expect(feedback).to include("* La clase `Foo` debería ser un `Bar`. Revisá si no te falta un _extends_ o _implements_ cerca de `Bar bar = new Foo();`.")}
  end
end
