# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'appmake/version'

Gem::Specification.new do |gem|
  gem.name          = "appmake"
  gem.version       = Appmake::VERSION
  gem.authors       = ["Sebastian Sito", "Sławomir Kołodziej"]
  gem.email         = ["sebastian@hypenode.com", "hfrntt@gmail.com"]
  gem.description   = %q{Appmake allows you to easily develop single-page apps in HTML5}
  gem.summary       = %q{Appmake app bootstrapper}
  gem.homepage      = "https://github.com/sebastiansito/appmake"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "thor"
  gem.add_dependency "listen"
  gem.add_dependency "rb-fsevent"
  gem.add_dependency "sass"
end
