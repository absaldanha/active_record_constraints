# frozen_string_literal: true

class Account < ActiveRecord::Base
  has_many :users

  has_unique_constraint :name
  has_check_constraint :name, name: "account_name_check"
end
