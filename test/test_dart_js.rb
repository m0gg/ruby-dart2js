require 'dart_js'
require 'test/unit'
require 'tempfile'

class TestDartJs < Test::Unit::TestCase
  def test_module
    assert_kind_of Module, DartJs
  end

  def test_compile
    Tempfile.open(%w(test .dart)) do |f|
      f.write <<-EOS
        main() {
          print('Hello, Dart!');
        }
      EOS
      f.flush
      of_path = File.join(Dir.tmpdir, 'dart_js_testrun.dart.js')
      dfile1 = DartJs.new(f, { :out_file => of_path })
      dfile1.compile
      assert File.exists?(of_path)
      dfile2 = DartJs.new(f)
      dfile2.compile
      assert File.exists?(dfile2.out_file)
      dfile3 = DartJs.new("main() { print('Hello, Dart!'); }")
      dfile3.compile
      assert File.exists?(dfile3.out_file)
    end
  end
end