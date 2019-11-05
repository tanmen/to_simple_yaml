
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "to_simple_yaml/version"

Gem::Specification.new do |spec|
  spec.name          = "to_simple_yaml"
  spec.version       = ToSimpleYaml::VERSION
  spec.authors       = ["tanmen"]
  spec.email         = ["yt.prog@gmail.com"]

  spec.summary       = "simpler output than to_yaml"
  spec.description   = "simpler output than to_yaml"
  spec.homepage      = "https://github.com/tanmen/to_simple_yaml"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
