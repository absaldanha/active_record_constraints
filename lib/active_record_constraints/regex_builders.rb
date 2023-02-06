# frozen_string_literal: true

module ActiveRecordConstraints
  module RegexBuilders
    mattr_accessor :builders, instance_accessor: false, default: {}

    def self.fetch
      adapter_name = ActiveRecord::Base.connection.adapter_name.downcase.to_sym

      builders.fetch(adapter_name)
    end

    builders.store(:postgresql, PostgreSQLRegexBuilder.new)
    builders.store(:mysql2, MySQLRegexBuilder.new)
  end
end
