require File.dirname(__FILE__) + '/../test_helper'
require 'jukebox_controller'

# Re-raise errors caught by the controller.
class JukeboxController; def rescue_action(e) raise e end; end

class JukeboxControllerTest < Test::Unit::TestCase
  def setup
    @controller = JukeboxController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
