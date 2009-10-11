require 'test_helper'

class BusinessCardTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert BusinessCard.new.valid?
  end
end
