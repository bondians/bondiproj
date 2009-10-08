require 'test_helper'

class AccountsTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Accounts.new.valid?
  end
end
