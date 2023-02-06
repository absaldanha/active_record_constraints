# frozen_string_literal: true

require "test_helper"
require "support/models/account"
require "support/models/user"
require "support/models/book"
require "support/models/tag"
require "support/models/book_tag"

class UniqueConstraintTest < ActiveRecordConstraints::TestCase
  def test_with_no_errors
    assert_difference -> { Account.count } => 2, -> { User.count } => 2 do
      assert_nothing_raised do
        Account.create!(name: "Account") do |account|
          User.create!(email: "user@mail.com", account: account)
        end

        Account.create!(name: "OtherAccount") do |other_account|
          User.create!(email: "other@mail.com", account: other_account)
        end
      end
    end
  end

  def test_when_other_error_occurs_it_propagates
    assert_no_difference -> { Account.count } do
      assert_raises ActiveRecord::NotNullViolation do
        Account.create!
      end
    end
  end

  def test_when_unique_constraint_is_violated
    Account.create!(name: "Account")

    assert_no_changes -> { Account.count }, from: 1 do
      other_account = Account.create(name: "Account")

      assert_equal other_account.errors.messages, { name: ["has already been taken"] }
      assert_equal other_account.constraint_errors.messages, { name: ["has already been taken"] }
    end
  end

  def test_unique_constraint_error_with_custom_message
    account = Account.create(name: "Account")
    user = User.create(email: "user@mail.com", account: account)
    other_user = User.create(email: "other@mail.com", account: account)

    Book.create(name: "Some Book", user: user, isbn: "0-3119-4771-9")

    assert_no_changes -> { Book.count }, from: 1 do
      book = Book.create(name: "Other Book", user: other_user, isbn: "0-3119-4771-9")

      assert_equal book.errors.messages, { isbn: ["Invalid ISBN"] }
      assert_equal book.constraint_errors.messages, { isbn: ["Invalid ISBN"] }
    end
  end

  def test_unique_constraint_error_with_composite_unique_index
    account = Account.create(name: "Account")

    User.create(email: "user@mail.com", account: account)

    assert_no_changes -> { User.count }, from: 1 do
      user = User.create(email: "user@mail.com", account: account)

      assert_equal user.errors.messages, { email: ["has already been taken"] }
      assert_equal user.constraint_errors.messages, { email: ["has already been taken"] }
    end
  end

  def test_unique_constraint_error_with_custom_key
    account = Account.create(name: "Account")
    user = User.create(email: "user@mail.com", account: account)

    Book.create(name: "Fancy Book", isbn: "0-3119-4771-9", user: user)

    assert_no_changes -> { Book.count }, from: 1 do
      book = Book.create(name: "Fancy Book", isbn: "0-9999-4771-9", user: user)

      assert_equal book.errors.messages, { name: ["has already been taken"] }
      assert_equal book.constraint_errors.messages, { name: ["has already been taken"] }
    end
  end

  def test_unique_constraint_error_with_custom_name
    account = Account.create(name: "Account")
    user = User.create(email: "user@mail.com", account: account)
    book = Book.create(name: "Foo", user: user, isbn: "0-3119-4771-9")
    tag = Tag.create(name: "fancy")

    BookTag.create(book: book, tag: tag)

    assert_no_changes -> { BookTag.count }, from: 1 do
      book_tag = BookTag.create(book: book, tag: tag)

      assert_equal book_tag.errors.messages, { book_id: ["has already been taken"] }
      assert_equal book_tag.constraint_errors.messages, { book_id: ["has already been taken"] }
    end
  end

  def test_validate_doesnt_clear_constraint_errors
    account = Account.create(name: "Account")

    User.create(email: "user@mail.com", account: account)

    assert_no_changes -> { User.count }, from: 1 do
      user = User.create(email: "user@mail.com", account: account)

      assert_not user.errors.empty?
      assert_not user.constraint_errors.empty?

      user.validate

      assert user.errors.empty?
      assert_not user.constraint_errors.empty?
    end
  end
end
