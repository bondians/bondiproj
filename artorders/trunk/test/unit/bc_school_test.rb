require 'test_helper'

class BcSchoolTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert BcSchool.new.valid?
  end
end
