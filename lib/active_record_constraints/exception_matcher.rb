# frozen_string_literal: true

module ActiveRecordConstraints
  class ExceptionMatcher
    attr_reader :constraint_name

    delegate :uniqueness_regex, :check_regex, :foreign_key_regex, to: :adapter

    def initialize(constraint_name)
      @constraint_name = constraint_name
    end

    def uniqueness_error?(error)
      uniqueness_regex(constraint_name).match?(error.message)
    end

    def check_error?(error)
      check_regex(constraint_name).match?(error.message)
    end

    def foreign_key_error?(error)
      foreign_key_regex(constraint_name).match?(error.message)
    end

    private

    def adapter
      RegexBuilders.fetch
    end
  end
end
