# frozen_string_literal: true

module ActiveRecordConstraints
  module Constraints
    class UniqueConstraint < BaseConstraint
      def around_save(record)
        yield
      rescue ActiveRecord::RecordNotUnique => error
        raise error unless matcher.uniqueness_error?(error)

        value = record.public_send(key)

        add_error(record, key, :taken, value: value, message: message)
      end
    end
  end
end
