require 'test_helper'

class TasksTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Tasks.new.valid?
  end
end
