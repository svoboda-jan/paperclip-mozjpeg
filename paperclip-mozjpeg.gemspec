# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paperclip-mozjpeg/version'

Gem::Specification.new do |spec|
  spec.name          = "paperclip-mozjpeg"
  spec.version       = PaperclipMozjpeg::VERSION
  spec.authors       = ["Jan Svoboda"]
  spec.email         = ["jan@mluv.cz"]

  spec.summary       = %q{JPEG and PNG compression processor for paperclip using MozJPEG.}
  spec.description   = %q{JPEG and PNG compression processor for paperclip using MozJPEG.}
  spec.homepage      = "https://github.com/svoboda-jan/paperclip-mozjpeg"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "minitest", "~> 5.4.2"

  spec.add_dependency "kt-paperclip"

end
