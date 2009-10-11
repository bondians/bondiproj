require 'test_helper'

class BusinessCardBatchTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert BusinessCardBatch.new.valid?
  end
end
