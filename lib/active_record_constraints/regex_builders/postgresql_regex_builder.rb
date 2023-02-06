# frozen_string_literal: true

module ActiveRecordConstraints
  module RegexBuilders
    class PostgreSQLRegexBuilder < BaseBuilder
      def uniqueness_regex(constraint_name)
        /violates unique constraint "#{constraint_name}"/
      end

      def check_regex(constraint_name)
        /violates check constraint "#{constraint_name}"/
      end

      def foreign_key_regex(constraint_name)
        /violates foreign key constraint "#{constraint_name}"/
      end
    end
  end
end
