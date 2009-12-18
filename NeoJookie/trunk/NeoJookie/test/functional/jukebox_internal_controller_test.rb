require File.dirname(__FILE__) + '/../test_helper'
require 'jukebox_internal_controller'

# Re-raise errors caught by the controller.
class JukeboxInternalController; def rescue_action(e) raise e end; end

class JukeboxInternalControllerTest < Test::Unit::TestCase
  def setup
    @controller = JukeboxInternalController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
