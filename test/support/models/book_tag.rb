# frozen_string_literal: true

class BookTag < ActiveRecord::Base
  belongs_to :book
  belongs_to :tag

  has_unique_constraint [:book_id, :tag_id], name: "book_tag_unique_index"
  has_association_constraint :tag, message: "unknown tag"
end
