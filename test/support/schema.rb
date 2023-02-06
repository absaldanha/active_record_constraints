# frozen_string_literal: true

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :accounts, if_not_exists: true do |t|
    t.string :name, index: { unique: true }, null: false

    t.check_constraint "LENGTH(name) > 3", name: "account_name_check"
  end

  create_table :users, if_not_exists: true do |t|
    t.string :email, null: false
    t.references :account, foreign_key: true, null: false

    t.index [:email, :account_id], unique: true

    t.check_constraint "email LIKE '%@%'", name: "user_email_check"
  end

  create_table :books, if_not_exists: true do |t|
    t.string :name, null: false
    t.string :isbn, index: { unique: true }, null: false
    t.references :user, foreign_key: { name: "author_foreign_key" }, null: false

    t.index [:user_id, :name], unique: true
  end

  create_table :tags, if_not_exists: true do |t|
    t.string :name, index: { unique: true }
  end

  create_table :book_tags, if_not_exists: true do |t|
    t.references :book, foreign_key: true, null: false
    t.references :tag, foreign_key: true, null: false

    t.index [:book_id, :tag_id], unique: true, name: "book_tag_unique_index"
  end
end
