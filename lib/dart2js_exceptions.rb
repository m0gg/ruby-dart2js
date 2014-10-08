module Dart2JsExceptions
  class CompilationException < RuntimeError
    attr_reader :cmd, :in_file, :result

    def initialize cmd, in_file, result
      super("dart2js failed to compile '#{in_file}'")
      @result = result;
      @cmd = cmd;
      @in_file = in_file;
    end
  end
end