require 'test_helper'

class DepartmentsTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Departments.new.valid?
  end
end
