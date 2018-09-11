require 'test_helper'

class BagTemplatesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bag_templates_index_url
    assert_response :success
  end

  test "should get show" do
    get bag_templates_show_url
    assert_response :success
  end

end
