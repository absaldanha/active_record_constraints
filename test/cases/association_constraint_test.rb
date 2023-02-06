# frozen_string_literal: true

require "test_helper"

class AssociationConstraintTest < ActiveRecordConstraints::TestCase
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
    assert_no_difference -> { User.count } do
      assert_raises ActiveRecord::NotNullViolation do
        Account.create(name: "Account") do |account|
          User.create
        end
      end
    end
  end

  def test_when_association_constraint_is_violated
    assert_no_changes -> { User.count }, from: 0 do
      user = User.create(email: "email@mail.com", account_id: Account.maximum(:id).to_i + 100)

      assert_equal user.errors.messages, { account_id: ["must exist"] }
      assert_equal user.constraint_errors.messages, { account_id: ["must exist"] }
    end
  end

  def test_association_constraint_error_with_custom_message
    account = Account.create(name: "Account")
    user = User.create(email: "mail@mail.com", account: account)
    book = Book.create(name: "Book", isbn: "random-isbn", user: user)

    assert_no_changes -> { BookTag.count }, from: 0 do
      book_tag = BookTag.create(book: book, tag_id: Tag.maximum(:id).to_i + 100)

      assert_equal book_tag.errors.messages, { tag_id: ["unknown tag"] }
      assert_equal book_tag.constraint_errors.messages, { tag_id: ["unknown tag"] }
    end
  end

  def test_association_constraint_error_with_custom_name
    assert_no_changes -> { Book.count }, from: 0 do
      book = Book.create(name: "Book", isbn: "isbn", user_id: User.maximum(:id).to_i + 90)

      assert_equal book.errors.messages, { user_id: ["must exist"] }
      assert_equal book.constraint_errors.messages, { user_id: ["must exist"] }
    end
  end
end
