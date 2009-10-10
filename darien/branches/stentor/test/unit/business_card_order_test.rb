require 'test_helper'

class BusinessCardOrderTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert BusinessCardOrder.new.valid?
  end
end
