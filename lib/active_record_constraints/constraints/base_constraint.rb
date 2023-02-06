# frozen_string_literal: true

module ActiveRecordConstraints
  module Constraints
    class BaseConstraint
      attr_reader :name, :message, :key, :matcher

      def initialize(name:, key:, message: nil)
        @name = name
        @message = message
        @key = key
        @matcher = ExceptionMatcher.new(name)
      end

      protected

      def add_error(record, ...)
        record.errors.add(...)
        record.constraint_errors.add(...)

        raise ActiveRecord::RecordInvalid, record
      end
    end
  end
end
