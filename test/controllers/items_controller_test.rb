require 'test_helper'

class ItemReferencesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get item_references_index_url
    assert_response :success
  end

  test "should get show" do
    get item_reference_show_url
    assert_response :success
  end

end
