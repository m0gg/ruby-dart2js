require 'tilt'
require 'tempfile'
require 'dart2js_exceptions'

class Dart2Js
  include Dart2JsExceptions

  class Template < Tilt::Template
    def prepare
      @compiler = Dart2Js.new data
    end

    def precompiled_template locals
      return @compiler.result
    end
  end

  class << self
    attr_writer :dart2js_binary

    def dart2js_binary
      @dart2js_binary ||= (ENV['DART2JS_SOURCE_PATH'] || find_dart2js_in_path || find_dart2js_in_sdk)
    end

    private
    def find_dart2js_in_path
      system('dart2js --version') ? 'dart2js' : false
    end

    def find_dart2js_in_sdk
      if root = ENV['DART_SDK_HOME']
        file = File.join(root, 'bin', 'dart2js')
        file if File.exist?(file)
      end
    end
  end

  attr_reader :data, :in_file, :result
  attr_accessor :pwd, :out_file, :out_dir, :dart2js_binary

  def initialize(file_or_data, options = {})
    @dart2js_binary = options[:dart2js_binary] || self.class.dart2js_binary

    if options[:out_file].is_a?(File)
      @out_file     = options[:out_file]
    elsif options[:out_file]
      @out_file     = File.new(options[:out_file])
    end

    if options[:out_dir]
      @out_dir      = options[:out_dir]
      @out_file   ||= File.join(@out_dir, uniqe_tmpfile_name)
    else
      @out_file   ||= Tempfile.open('dart2js_output')
    end

    if file_or_data.is_a?(File)
      @in_file = file_or_data
    elsif File.exist?(file_or_data)
      @in_file = File.new(file_or_data)
    else
      @data = file_or_data
      @pwd  = options[:pwd]
    end
  end

  def compile(minify = true)
    prepare_input
    prepare_output
    cmd = [ @dart2js_binary,
            minify ? ' -m ': nil,
            %Q{-o"#{output_path}"},
            input_path ].join(' ')
    process = IO.popen(cmd, 'r')
    @result = process.read
    process.close
    return_code = $?.to_i
    if return_code != 0
      raise CompilationException.new(self, cmd)
    else
      get_js_content
    end
  end

  def get_js_content
    File.read(@out_file)
  end

  def close
    [@in_file, @out_file].each do |f|
      f.close! if f.respond_to?(:close!)
    end
  end

  private
  def input_path
    @in_file.path
  end

  def output_path
    @out_file.path
  end

  def prepare_input
    if data
      @in_file = Tempfile.open('dart2js_input', @pwd)
      @in_file.write data
      @in_file.close
    end
    unless File.exists?(input_path)
      raise PrepareInputException.new(self, "prepare_input ran but 'in_file' does not exist!")
    end
  end

  def prepare_output
    if !@out_file.is_a?(Tempfile) && File.exists?(output_path)
      raise PrepareOutputException.new(self, "Won't overwrite existing file that is not a 'Tempfile''")
    end
  end

  def uniqe_tmpfile_name(ext = 'js')
    "dart2js_#{self.object_id}_#{Time.now.usec}.#{ext}"
  end
end
