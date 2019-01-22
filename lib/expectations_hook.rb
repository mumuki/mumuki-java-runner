class JavaExpectationsHook < Mumukit::Templates::MulangExpectationsHook
  include_smells true

  def language
    'Java'
  end

  def compile_content(content)
    return content unless content.is_a?(Hash)

    content.values.join("\n").gsub(/import .+/, '')
  end

  def default_smell_exceptions
    LOGIC_SMELLS + FUNCTIONAL_SMELLS
  end
end
