require 'test_helper'

class CircuitControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get solve" do
    get :solve
    assert_response :success
  end

end
