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

    def explain_incompatible_types(_, result)
      (/#{error} incompatible types: (.*) cannot be converted to (.*)#{near_regex}/.match result).try do |it|
        {down: it[1], up: it[2], near: it[3]}
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
      type, name = parse_symbol symbol

      I18n.t "symbol_#{type}", { name: name, default: "`#{type} #{name}`" }
    end

    def parse_symbol(result)
      parts = /^(\w+) (.+)$/.match result
      [parts[1], parts[2]]
    end
  end
end
