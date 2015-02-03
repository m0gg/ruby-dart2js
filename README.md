# Dart2Js [![ruby-dart2js API Documentation](https://www.omniref.com/ruby/gems/ruby-dart2js.png)](https://www.omniref.com/ruby/gems/ruby-dart2js) [![Gem Version](https://badge.fury.io/rb/ruby-dart2js.svg)](http://badge.fury.io/rb/ruby-dart2js) #

### Idea ###

Provide automated transcoding from [Dart](https://www.dartlang.org/ 'dartlang.org') to Javascript.

### Setup ###

###### Add gem ######

`Gemfile`

    gem 'ruby-dart2js', :git => https://github.com/m0gg/ruby-dart2js.git

###### Find SDK ######

`DartJs` will look for the `dart2js` binary in the following order:

  1. `DART2JS_SOURCE_PATH`  direct path to binary `env DARTJS_SOURCE_PATH=/opt/dart-sdk/bin/dart2js`
  2. `DART_SDK_HOME`  path to sdk `env DART_SDK_HOME=/opt/dart-sdk`
  3. `PATH`  looks for dart2js in your PATH-variable

### Usage ###

    dart_compiler = Dart2Js.new(file, options)
    dart_compiler.compile
    dart_compiler.get_js_content
    dart_compiler.out_file

Initialization takes either dart-sourcecode directly or an instance of `File` as first argument and
an options-hash as second argument. `:dart2js_binary` and `:out_file` may be provided with the options-hash.

`dart_compiler.compile` actually runs the `dart2js` command, the output of the run will be saved in `@result` and
the final js stays in `@out_file` and may be read with `dart_compiler.get_js_content`.

With version 0.2.0 `Dart2Js::compile` now accepts a boolean argument for minifying, it's optional and `true` by default.
