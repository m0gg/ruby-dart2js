class DartJs
  class << self
    attr_writer :dart2js_binary

    def dart2js_binary
      @dart2js_binary ||= ENV['DARTJS_SOURCE_PATH']
    end
  end

  attr_reader :data, :input_file, :result
  attr_accessor :out_file, :dart2js_binary

  def initialize(file_or_data, options = {})
    @dart2js_binary = options[:dart2js_binary] || self.class.dart2js_binary
    @out_file = options[:out_file] || File.join(Dir.tmpdir, "dart2js_#{self.object_id}_#{Time.now.usec}.js")
    if file_or_data.respond_to?(:path)
      throw 'File not found!' unless File.exists?(file_or_data)
      @input_file = file_or_data
    else
      @data = file_or_data
    end
  end

  def compile
    begin
      cmd_args = [ @dart2js_binary ]
      cmd_args << %Q{-o"#{out_file}"}
      cmd_args << in_file = prepare_input.path
      cmd = cmd_args.join(' ')
      process = IO.popen(cmd)
      @result = process.read
    ensure
      in_file.close! if in_file.respond_to?(:close!) && in_file != @input_file
    end
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