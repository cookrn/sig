$:.push File.expand_path( '../lib' , __FILE__ )

require 'sig/version'

Gem::Specification.new do | s |
  s.name        = 'sig'
  s.version     = Sig::VERSION
  s.authors     = [ 'Ryan Cook' ]
  s.email       = [ 'cookrn@gmail.com' ]
  s.homepage    = 'https://github.com/cookrn/sig'
  s.summary     = "Sig v##{ Sig::VERSION }"
  s.description = 'Obfuscation and ASCII art'

  s.bindir = 'bin'
  s.executables = [ 'sig' ]
  s.files = Dir[ '{lib}/**/*' ]
  s.files += [
    'Rakefile',
    'README.md'
  ]

  s.test_files = Dir[ 'test/**/*' ] + Dir[ 'features/**/*' ]

  s.add_dependency 'artii'       , '~> 2.0'
  s.add_dependency 'ruby_parser' , '~> 3.0'
  s.add_dependency 'ruby2ruby'   , '~> 2.0'

  s.add_development_dependency 'cucumber' , '~> 1.2'
  s.add_development_dependency 'minitest' , '~> 4.2'
end
