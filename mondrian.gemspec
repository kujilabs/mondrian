# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mondrian/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["stellard"]
  gem.email         = ["scott.ellard@gmail.com"]
  gem.description   = %q{Schema DSL for mondrian}
  gem.summary       = %q{Ruby DSL for Mondrian Schema Definitions, Based on https://github.com/rsim/mondrian-olap}
  gem.homepage      = "https://github.com/kujilabs/mondrian"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "mondrian"
  gem.require_paths = ["lib"]
  gem.version       = Mondrian::VERSION
  
  gem.add_dependency 'nokogiri', '~> 1.5.0'
end
