# frozen_string_literal: true

module ActiveRecordConstraints
  module Constraints
    def self.unique(name:, message:, key:)
      UniqueConstraint.new(name: name, message: message, key: key)
    end

    def self.check(name:, message:, key:)
      CheckConstraint.new(name: name, message: message, key: key)
    end

    def self.foreign_key(name:, message:, key:)
      ForeignKeyConstraint.new(name: name, message: message, key: key)
    end
  end
end
