module Dart2JsExceptions
  class Dart2JsException < Exception
    def initialize(compiler)
      @instance = compiler
    end
  end

  class CompilationException < Dart2JsException
    def initialize(compiler, cmd)
      super(compiler)
      @cmd = cmd;
    end

    def message
      "dart2js compilation '#{@cmd}' failed:\n #{@instance.result}"
    end

  end
  class PrepareInputException < Dart2JsException
    def initialize(compiler, reason)
      super(compiler)
      @reason = reason
    end

    def message
      "dart2js prepare_input failed\n in_file: #{@instance.in_file}\n input_path: #{@instance.input_path}\n reason: #{@reason}"
    end
  end

  class PrepareOutputException < Dart2JsException
    def initialize(compiler, reason)
      super(compiler)
      @reason = reason
    end

    def message
      "dart2js prepare_output failed\n out_file: #{@instance.out_file}\n output_path: #{@instance.output_path}\n reason: #{@reason}"
    end
  end
end