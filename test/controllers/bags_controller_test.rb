require 'test_helper'

class BagsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bags_index_url
    assert_response :success
  end

  test "should get show" do
    get bags_show_url
    assert_response :success
  end

end
