# frozen_string_literal: true

require "delegate"
require "zeitwerk"
require "active_record"

loader = Zeitwerk::Loader.for_gem

loader.inflector.inflect(
  "postgresql_regex_builder" => "PostgreSQLRegexBuilder",
  "mysql_regex_builder" => "MySQLRegexBuilder"
)

loader.setup

module ActiveRecordConstraints
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.include(ActiveRecordConstraints::Concern) 
  end
end
