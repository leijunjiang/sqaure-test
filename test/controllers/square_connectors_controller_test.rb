require "test_helper"

class SquareConnectorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @square_connector = square_connectors(:one)
  end

  test "should get index" do
    get square_connectors_url
    assert_response :success
  end

  test "should get new" do
    get new_square_connector_url
    assert_response :success
  end

  test "should create square_connector" do
    assert_difference('SquareConnector.count') do
      post square_connectors_url, params: { square_connector: { client_id: @square_connector.client_id, client_secret: @square_connector.client_secret } }
    end

    assert_redirected_to square_connector_url(SquareConnector.last)
  end

  test "should show square_connector" do
    get square_connector_url(@square_connector)
    assert_response :success
  end

  test "should get edit" do
    get edit_square_connector_url(@square_connector)
    assert_response :success
  end

  test "should update square_connector" do
    patch square_connector_url(@square_connector), params: { square_connector: { client_id: @square_connector.client_id, client_secret: @square_connector.client_secret } }
    assert_redirected_to square_connector_url(@square_connector)
  end

  test "should destroy square_connector" do
    assert_difference('SquareConnector.count', -1) do
      delete square_connector_url(@square_connector)
    end

    assert_redirected_to square_connectors_url
  end
end
