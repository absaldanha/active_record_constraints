# frozen_string_literal: true

module ActiveRecordConstraints
  module RegexBuilders
    class MySQLRegexBuilder < BaseBuilder
      def uniqueness_regex(constraint_name)
        /Duplicate entry .* for key '.*\.#{constraint_name}'/
      end

      def check_regex(constraint_name)
        /Check constraint '#{constraint_name}' is violated/
      end

      def foreign_key_regex(constraint_name)
        /a foreign key constraint fails .* CONSTRAINT `#{constraint_name}`/
      end
    end
  end
end
