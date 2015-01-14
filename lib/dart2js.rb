require 'tempfile'
require 'dart2js_exceptions'

class Dart2Js < Sprockets::Processor
  class << self
    attr_writer :dart2js_binary

    def dart2js_binary
      @dart2js_binary ||= (ENV['DART2JS_SOURCE_PATH'] || find_dart2js_in_path || find_dart2js_in_sdk)
    end

    private
    def find_dart2js_in_path
      system('dart2js -h') ? 'dart2js' : false
    end

    def find_dart2js_in_sdk
      if root = ENV['DART_SDK_HOME']
        file = File.join(root, 'bin', 'dart2js')
        file if File.exist?(file)
      end
    end
  end

  attr_reader :data, :input_file, :result
  attr_accessor :out_file, :out_dir, :dart2js_binary

  def initialize(file_or_data, options = {})
    @dart2js_binary = options[:dart2js_binary] || self.class.dart2js_binary
    @out_dir = options[:out_dir] if options[:out_dir]
    @out_file = options[:out_file] || File.join((@out_dir || Dir::tmpdir), "dart2js_#{self.object_id}_#{Time.now.usec}.js")
    if file_or_data.respond_to?(:path)
      if File.exists?(file_or_data)
        @input_file = file_or_data
      else
        throw 'File not found!'
      end
    else
      @data = file_or_data
    end
  end

  def compile minify=true
    cmd = [ @dart2js_binary,
            minify ? ' -m ' || '',
            %Q{-o"#{out_file}"},
            in_file = prepare_input.path ].join(' ')
    process = IO.popen(cmd, 'r')
    @result = process.read
    process.close
    return_code = $?.to_i
    return_code == 0 ? true : Dart2JsExceptions::CompilationException.new(cmd, in_file, @result)
  end

  def get_js_content
    File.read(@out_file)
  end

  private
  def prepare_input
    if data
      tmp_file = Tempfile.open(%w(dart2js_tmpread .dart))
      tmp_file.write data
      tmp_file.flush
      tmp_file
    else
      @input_file
    end
  end
end