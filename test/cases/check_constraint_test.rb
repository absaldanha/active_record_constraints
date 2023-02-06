# frozen_string_literal: true

require "test_helper"

class CheckConstraintTest < ActiveRecordConstraints::TestCase
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

  def test_when_check_constraint_is_violated
    assert_no_changes -> { Account.count }, from: 0 do
      account = Account.create(name: "Foo")

      assert_equal account.errors.messages, { name: ["is invalid"] }
      assert_equal account.constraint_errors.messages, { name: ["is invalid"] }
    end
  end

  def test_check_constraint_error_with_custom_message
    account = Account.create(name: "Account")

    assert_no_changes -> { User.count }, from: 0 do
      user = User.create(email: "abc", account: account)

      assert_equal user.errors.messages, { email: ["is invalid email"] }
      assert_equal user.constraint_errors.messages, { email: ["is invalid email"] }
    end
  end

  def test_validate_doesnt_clear_constraint_errors
    account = Account.create(name: "Account")

    User.create(email: "user@mail.com", account: account)

    assert_no_changes -> { User.count }, from: 1 do
      user = User.create(email: "abc", account: account)

      assert_not user.errors.empty?
      assert_not user.constraint_errors.empty?

      user.validate

      assert user.errors.empty?
      assert_not user.constraint_errors.empty?
    end
  end
end
