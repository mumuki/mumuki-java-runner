class JavaFeedbackHook < Mumukit::Hook
  def run!(request, results)
    content = request.content
    test_results = results.test_results[0]

    JavaExplainer.new.explain(content, test_results) if test_results.is_a? String
  end

  class JavaExplainer < Mumukit::Explainer

    def near_regex()
      '.*[\t \n]* *(.*)\n[ \t]+\^'
    end

    def symbol_regex()
      '.*[\t \n]*symbol:*(.*)'
    end

    def location_regex()
      '.*[\t \n]*location:*(.*)'
    end

    def error()
      '[eE]rror:'
    end

    def explain_missing_semicolon(_, result)
      (/#{error} ';' expected#{near_regex}/.match result).try do |it|
        {near: it[1]}
      end
    end
    def explain_missing_bracket(_, result)
      (/#{error} '\(' expected#{near_regex}/.match result).try do |it|
        {near: it[1]}
      end
    end
    def explain_cannot_find_symbol(_, result)
      (/#{error} cannot find symbol#{near_regex}#{symbol_regex}#{location_regex}/.match result).try do |it|
        {near: it[1], symbol: it[2].strip, location: it[3].strip}
      end
    end
  end
end
