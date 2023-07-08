require 'rails_helper'
require 'webmock/rspec'

RSpec.describe SquareConnectorsController, type: :controller do
  let(:client_id)     {ENV["CLIENT_ID"]}
  let(:client_secret) {ENV["CLIENT_SECRET"]}
  describe "#create" do
    before do
      SquareConnector.destroy_all
      get :create, params: {square_connector: {client_id: client_id, client_secret: client_secret}}
    end

    it "should successfully create SquareConnector" do
      expect(SquareConnector.count) == 1
    end

    it "should successfully create SquareConnector with access_token and other attributes" do
      connector = SquareConnector.last
      expect(response).to redirect_to "https://connect.squareupsandbox.com/oauth2/authorize?client_id=#{connector.client_id}&scope=ORDERS_WRITE%20ORDERS_READ%20BANK_ACCOUNTS_READ%20MERCHANT_PROFILE_READ%20PAYMENTS_READ%20SETTLEMENTS_READ"
    end
  end

  describe "#callback" do
    before do
      SquareConnector.destroy_all
      @square_connector = SquareConnector.create({client_id: client_id, client_secret: client_secret})
      body_request =  {
        "client_id"=>client_id,
        "client_secret"=>client_secret,
        "code"=>"auth_code",
        "grant_type"=>"authorization_code"
      }.to_json

      headers_request = {:content_type=>"application/json", :square_version=>"2023-06-08"}

      body_response = {
        token_type: "bearer",
        refresh_token: "refresh_token",
        access_token: "access_token",
        expires_at: "2022"
      }.to_json

      headers_response = {
        'Content-Type'=> 'application/json;charset=UTF-8'
      }

      stub_request(:post, "https://connect.squareupsandbox.com/oauth2/token").
                    with(:body => body_request ,
                        :headers =>headers_request).
                    to_return(:status => 200,
                              :body => body_response,
                              :headers => headers_response)

      get :callback, params: {code: 'auth_code'}
    end

    it "should update acess_token" do
      @square_connector.reload
      expect(@square_connector.access_token).to eq("access_token")
    end
  end
end

