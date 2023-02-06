# frozen_string_literal: true

class User < ActiveRecord::Base
  belongs_to :account

  has_unique_constraint [:email, :account_id]
  has_check_constraint :email, name: "user_email_check", message: "is invalid email"
  has_association_constraint :account
end
