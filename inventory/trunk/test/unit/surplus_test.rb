require 'test_helper'

class SurplusTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Surplus.new.valid?
  end
end
