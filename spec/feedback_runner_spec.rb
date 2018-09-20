require_relative 'spec_helper'

describe JavaFeedbackHook do
  before {I18n.locale = :es}

  let(:feedback) {JavaFeedbackHook.new.run!(request, OpenStruct.new(test_results: test_results))}

  describe 'when TestHook is run before FeedbackHook' do
    def req(content, test='')
      struct content: content, test: test
    end

    let(:server) {JavaTestHook.new}
    let!(:test_results) {server.run!(server.compile(request))}

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

      it {expect(feedback).to include("* No se encontró la definición de el método `getAnInt()` en la clase `Foo`")}
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

    context 'missing method with type' do
      let(:request) {req(%q{
    class Golondrina {
    }}, %q{
      public void testFoo(){
        Golondrina golondrina = new Golondrina();
        golondrina.reanimarConUnChocolate();
      }
    })}

      it {expect(feedback).to include("* No se encontró la definición de el método `reanimarConUnChocolate()` en la variable `golondrina` de tipo `Golondrina`")}
    end

    context 'missing class' do
      let(:request) {req('', %q{
      public void testFoo() {
        Assert.assertEquals(2, new Foo());
      }
    })}

      it {expect(feedback).to eq("* No se encontró la definición de la clase `Foo`")}
    end

    context 'missing variable' do
      let(:request) {req('class Main {}', %q{
      public void testFoo() {
        Assert.assertEquals(2, Main.unaVariable);
      }
    })}

      it {expect(feedback).to include("* No se encontró la definición de la variable `unaVariable` en la clase `Main`")}
    end

    context 'missing parameter type' do
      let(:request) {req(%q{
    class Foo {
      public int plusTwo(aNumber) {
        return 2 + aNumber;
      }
    }}, %q{
      public void testFoo(){
        Assert.assertEquals(2, new Foo().plusTwo(3));
      }
    })}

      it {expect(feedback).to include("* Parece que falta el tipo de un parámetro cerca de `public int plusTwo(aNumber) {`")}
    end

    context 'wrong types - classes' do
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

    context 'wrong types - primitives' do
      let(:request) {req(%q{
    class Foo {
      boolean bar() {
        return 3;
      }
    }}, %q{
      public void testFoo(){
        new Foo().bar();
      }
    })}

      it {expect(feedback).to include("* Estás devolviendo un `int` donde se necesitaba un `boolean` cerca de `return 3;`")}
    end

    context 'private method should be public' do
      let(:request) {req(%q{
    interface Reclamo {
      public void agregarEn(LinkedList reclamos);
    }
    class ReclamoComun implements Reclamo {
      private void agregarEn(LinkedList reclamos) {
      }
    }}, %q{
      public void testFoo(){
        new ReclamoComun().agregarEn(new LinkedList());
      }
    })}

      it {expect(feedback).to include("* El método `agregarEn(LinkedList)` en `ReclamoComun` debería ser público. Revisá si tiene la visibilidad correcta cerca de `private void agregarEn(LinkedList reclamos) {`.")}
    end
  end

  describe 'when ExpectationsHook is run before FeedbackHook' do
    def reqq(content)
      struct expectations: [], content: content
    end

    def compile_and_run(request)
      runner.run!(runner.compile(request))
    end

    let(:request) { reqq(code) }
    let(:runner) { JavaExpectationsHook.new }
    let(:test_results) do
      begin
      compile_and_run(request)
      rescue Mumukit::CompilationError => e
      [e.to_s]
      end
    end

    context 'missing semicolon' do
      let(:code) {%q{
        class Foo {
          public void testFoo(){
            Assert.assertEquals(2, 3)
          }
        }
      }}

      it {expect(feedback).to include('Fijate si no te falta un `;` o una `{` cerca de la línea')}
    end

    context 'missing parenthesis' do
      let(:code) {%q{
        class Foo {
          public void testFoo){
            Assert.assertEquals(2, 3);
          }
        }
      }}

      it {expect(feedback).to include('Fijate si no te falta un `(` o te sobra un `)` cerca de la línea')}
    end

    context 'missing bracket' do
      let(:code) {%q{
        class Foo {
          public void testFoo()){
            Assert.assertEquals(2, 3);
          }
        }
      }}

      it {expect(feedback).to include('Fijate si no te falta un `(` o te sobra un `)` cerca de la línea')}
    end

    context 'missing parameter type' do
      let(:code) {%q{
      class Foo {
        public int plusTwo(aNumber) {
          return 2 + aNumber;
        }
      }}}

      it {expect(feedback).to include('Asegurate también de que todos los parámetros declaren sus tipos')}
    end
  end

end
