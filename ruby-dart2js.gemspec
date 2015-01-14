$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'ruby-dart2js'
  s.version     = '0.2.0'
  s.authors     = ['Marcel Sackermann']
  s.email       = %w(marcel@m0gg.org)
  s.homepage    = 'https://github.com/m0gg/ruby-dart2js'
  s.summary     = 'Provides dart2js compiling for compatibility.'
  s.description = ''

  s.files = Dir['{lib}/**/*'] + %w(MIT-LICENSE Rakefile)
  s.test_files = Dir['test/**/*']
end
