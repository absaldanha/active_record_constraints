# frozen_string_literal: true

class Book < ActiveRecord::Base
  belongs_to :user

  has_unique_constraint :isbn, message: "Invalid ISBN"
  has_unique_constraint [:user_id, :name], key: :name
  has_association_constraint :user, name: "author_foreign_key"
end
