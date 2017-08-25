class JavaFileHook < Mumukit::Templates::FileHook
  isolated true

  def tempfile_extension
    '.java'
  end

  def post_process_file(file, result, status)
    if result.include? '!!SUBMISSION FINISHED WITH COMPILATION ERROR!!'
      [result, :errored]
    else
      super
    end
  end
end
