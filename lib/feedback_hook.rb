class JavaFeedbackHook < Mumukit::Hook
  def run!(request, results)
    content = request.content
    test_results = results.test_results[0]

    JavaExplainer.new.explain(content, test_results) if test_results.is_a? String
  end

  class JavaExplainer < Mumukit::Explainer

    def explain_missing_semicolon(_, result)
      missing_character result, ';'
    end

    def explain_missing_parenthesis(_, result)
      missing_character result, '\('
    end

    def explain_missing_bracket(_, result)
      missing_character result, '\{'
    end

    def explain_missing_parameter_type(_, result)
      (/#{error} <identifier> expected#{near_regex}/.match result).try do |it|
        {near: it[1]}
      end
    end

    def explain_missing_return_statement(_, result)
      (/#{error} missing return statement#{near_regex}/.match result).try do |it|
        {near: it[1]}
      end
    end

    def explain_cannot_find_symbol(_, result)
      (/#{error} cannot find symbol#{near_regex}#{symbol_regex}#{location_regex}/.match result).try do |it|
        symbol = it[2].strip
        location = it[3].strip

        {near: it[1], symbol: localize_symbol(symbol), at_location: at_location(symbol, location) }
      end
    end

    def explain_lossy_conversion(_, result)
      (/#{error} incompatible types: possible lossy conversion from (.*) to (.*)#{near_regex}/.match result).try do |it|
        { from: it[1], to: it[2], near: it[3] }
      end
    end

    def explain_incompatible_types(_, result)
      (/#{error} incompatible types: (.*) cannot be converted to (.*)#{near_regex}/.match result).try do |it|
        actual = it[1]
        expected = it[2]
        near = it[3]

        { message: I18n.t(
                     primitive_types.include?(actual) || primitive_types.include?(expected) ?
                       :incompatible_types_primitives :
                       :incompatible_types_classes,
                     { actual: actual, expected: expected, near: near }
                   ) }
      end
    end

    def explain_unexpected_close_curly(_, result)
      (/\(line (.*), .*\):\nunexpected CloseCurly/.match result).try do |it|
        {line: it[1]}
      end
    end

    def explain_unexpected_close_paren(_, result)
      (/\(line (.*), .*\):\nunexpected CloseParen/.match result).try do |it|
        {line: it[1]}
      end
    end

    def explain_implemented_method_should_be_public(_, result)
     (/#{error} #{symbol_name} in #{symbol_name} cannot implement #{symbol_name} in #{symbol_name}#{near_regex}\n  attempting to assign weaker access privileges/.match result).try do |it|
       {method: it[1], class: it[2], near: it[5]}
     end
    end

    private

    def start_regex(symbol=' ')
      /.*[\t \n]*#{symbol}*(.*)/
    end

    def near_regex
      /#{start_regex}\n[ \t]+\^/
    end

    def symbol_regex
      start_regex 'symbol:'
    end

    def location_regex
      start_regex 'location:'
    end

    def symbol_name
      "([\\w\\(\\)]+)"
    end

    def primitive_types
      ['byte', 'short', 'int', 'long', 'float', 'double', 'boolean', 'char']
    end

    def error
      '[eE]rror:'
    end

    def missing_character(result, character)
      (/#{error} '#{character}' expected#{near_regex}/.match result).try do |it|
        {near: it[1]}
      end
    end

    def at_location(symbol, location)
      symbol_type, _ = parse_symbol symbol
      return '' if symbol_type == 'class'

      ' ' + I18n.t(:at_location, {
        location: localize_symbol(location)
      })
    end

    def localize_symbol(symbol)
      symbol_type, name, type = parse_symbol symbol
      i18n_key = "symbol_#{symbol_type}"
      return "`#{symbol}`" unless I18n.exists? i18n_key

      I18n.t(i18n_key, { name: name }) + localize_of_type(type)
    end

    def localize_of_type(type)
      return '' if type.nil?

      ' ' + I18n.t(:of_type, type: type)
    end

    def parse_symbol(result)
      parts = /^(\w+) #{symbol_name}( of type (\w+))?/.match result
      return ['', '', ''] if parts.nil?

      [parts[1], parts[2], parts[4]]
    end
  end
end
