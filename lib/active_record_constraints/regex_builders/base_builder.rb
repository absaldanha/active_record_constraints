# frozen_string_literal: true

module ActiveRecordConstraints
  module RegexBuilders
    class BaseBuilder
      def uniqueness_regex(_constraint_name); end
      def check_regex(_constraint_name); end
      def foreign_key_regex(_constraint_name); end
    end
  end
end
