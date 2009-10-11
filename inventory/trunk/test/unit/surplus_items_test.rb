require 'test_helper'

class SurplusItemsTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert SurplusItems.new.valid?
  end
end
