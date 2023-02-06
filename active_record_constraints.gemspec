# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "active_record_constraints/version"

Gem::Specification.new do |spec|
  spec.name          = "active_record_constraints"
  spec.version       = ActiveRecordConstraints::Version::STRING
  spec.authors       = ["Alexandre Saldanha"]
  spec.email         = ["absaldanha@protonmail.com"]
  spec.summary       = "Database constraints better handled"
  spec.license       = "MIT"

  spec.required_ruby_version = [">= 2.7.0", "< 3.2"]

  spec.metadata = {
    "source_code_uri" => "https://github.com/absaldanha/active_record_constraints"
  }

  spec.files = Dir["lib/**/*"]

  spec.require_path = "lib"

  spec.add_dependency "activerecord", "> 6.1", "< 8"
  spec.add_dependency "zeitwerk", "~> 2.4"

  spec.add_development_dependency "pg", "~> 1.4"
  spec.add_development_dependency "mysql2", "~> 0.5.5"
  spec.add_development_dependency "sqlite3", "~> 1.6"

  spec.add_development_dependency "minitest", "~> 5.17"
  spec.add_development_dependency "minitest-focus", "~> 1.2"
  spec.add_development_dependency "minitest-reporters", "~> 1.4"
  spec.add_development_dependency "minitest-hooks", "~> 1.5"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 1.41"
  spec.add_development_dependency "rubocop-performance", "~> 1.15"
  spec.add_development_dependency "simplecov", "0.22.0"
end
