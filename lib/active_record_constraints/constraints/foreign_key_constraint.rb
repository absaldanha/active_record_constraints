# frozen_string_literal: true

module ActiveRecordConstraints
  module Constraints
    class ForeignKeyConstraint < BaseConstraint
      def around_save(record)
        yield
      rescue ActiveRecord::InvalidForeignKey => error
        raise error unless matcher.foreign_key_error?(error)

        foreign_key = foreign_key_for(record.class)
        value = record.public_send(foreign_key)

        add_error(record, foreign_key, :required, value: value, message: message)
      end

      private

      def foreign_key_for(klass)
        klass.reflect_on_association(key).foreign_key
      end
    end
  end
end
