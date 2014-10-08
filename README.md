# DartJs

### Idea

Provide automated transcoding from [Dart](https://www.dartlang.org/ 'dartlang.org') to Javascript.

### Setup

###### Add gem

`Gemfile`

    gem 'ruby-dart_js', :git => https://github.com/m0gg/ruby-dart_js.git

###### Find SDK

`DartJs` will look for the `dart2js` binary in the following order:

  1. `DART2JS_SOURCE_PATH`  direct path to binary `env DARTJS_SOURCE_PATH=/opt/dart-sdk/bin/dart2js`
  2. `DART_SDK_HOME`  path to sdk `env DART_SDK_HOME=/opt/dart-sdk`
  3. `PATH`  looks for dart2js in your PATH-variable

### Usage

    transcoder = Dart2Js.new(file, options)
    transcoder.compile
    transcoder.get_js_content
    transcoder.out_file

Initialization takes either dart-sourcecode directly or an instance of `File` as first argument and
an options-hash as second argument. `:dart2js_binary` and `:out_file` may be provided with the options-hash.

`transcoder.compile` actually runs the `dart2js` command, the output of the run will be saved in `@result` and
the final js stays in `@out_file` and may be read with `transcoder.get_js_content`.
