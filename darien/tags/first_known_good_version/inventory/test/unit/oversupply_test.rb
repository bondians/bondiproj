require 'test_helper'

class OversupplyTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Oversupply.new.valid?
  end
end
