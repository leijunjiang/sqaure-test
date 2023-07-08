require "application_system_test_case"

class SquareConnectorsTest < ApplicationSystemTestCase
  setup do
    @square_connector = square_connectors(:one)
  end

  test "visiting the index" do
    visit square_connectors_url
    assert_selector "h1", text: "Square Connectors"
  end

  test "creating a Square connector" do
    visit square_connectors_url
    click_on "New Square Connector"

    fill_in "Client", with: @square_connector.client_id
    fill_in "Client secret", with: @square_connector.client_secret
    click_on "Create Square connector"

    assert_text "Square connector was successfully created"
    click_on "Back"
  end

  test "updating a Square connector" do
    visit square_connectors_url
    click_on "Edit", match: :first

    fill_in "Client", with: @square_connector.client_id
    fill_in "Client secret", with: @square_connector.client_secret
    click_on "Update Square connector"

    assert_text "Square connector was successfully updated"
    click_on "Back"
  end

  test "destroying a Square connector" do
    visit square_connectors_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Square connector was successfully destroyed"
  end
end
