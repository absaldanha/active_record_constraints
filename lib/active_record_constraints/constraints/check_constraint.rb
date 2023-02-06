# frozen_string_literal: true

module ActiveRecordConstraints
  module Constraints
    class CheckConstraint < BaseConstraint
      def around_save(record)
        yield
      rescue ActiveRecord::StatementInvalid => error
        raise error unless matcher.check_error?(error)

        value = record.public_send(key)

        add_error(record, key, :invalid, value: value, message: message)
      end
    end
  end
end
