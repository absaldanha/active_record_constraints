# frozen_string_literal: true

if ENV["COVERAGE"]
  require "simplecov"
end

require "bundler/setup"
require "active_support/testing/assertions"
require "active_support/testing/tagged_logging"
require "active_record_constraints"
require "minitest/autorun"
require "minitest/focus"
require "minitest/reporters"
require "minitest/hooks/test"
require "support/database_config"

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

DatabaseConfig.setup!

module ActiveRecordConstraints
  class TestCase < Minitest::Test
    include Minitest::Hooks
    include ActiveSupport::Testing::Assertions
    include ActiveSupport::Testing::TaggedLogging

    def around
      ActiveRecord::Base.transaction(joinable: false) do
        super

        raise ActiveRecord::Rollback
      end
    end
  end
end
