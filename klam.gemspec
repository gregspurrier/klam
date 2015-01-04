lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'klam/version'

Gem::Specification.new do |s|
  s.name        = 'klam'
  s.version     = Klam::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = 'MIT'
  s.authors     = ['Greg Spurrier']
  s.email       = ['greg@sourcematters.org']
  s.homepage    = 'https://github.com/gregspurrier/klam'
  s.summary     = %q{Klam is a Ruby implementation of the Kl.}
  s.description = %q{Klam is a Ruby implementation of Kl, the small Lisp on top of which the Shen programming language is implemented.}

  s.required_ruby_version     = '>= 1.9.3'

  s.add_development_dependency 'rake', '~> 10.4', '>= 10.4'
  s.add_development_dependency 'rspec', '~> 3.1', '>= 3.1.0'
  s.add_development_dependency 'rspec-autotest', '~> 1.0', '>= 1.0.0'
  s.add_development_dependency 'ZenTest', '~> 4.11', '>= 4.11'

  git_files            = `git ls-files`.split("\n") rescue ''
  s.files              = git_files
  s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths      = ['lib']
end
