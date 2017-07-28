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

    def explain_missing_return_statement(_, result)
      (/#{error} missing return statement#{near_regex}/.match result).try do |it|
        {near: it[1]}
      end
    end

    def explain_cannot_find_symbol(_, result)
      (/#{error} cannot find symbol#{near_regex}#{symbol_regex}#{location_regex}/.match result).try do |it|
        {near: it[1], symbol: it[2].strip, location: it[3].strip}
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

  end
end
