require 'rails_helper'
require 'webmock/rspec'

RSpec.describe SquareConnectorsController, type: :controller do
  let(:client_id)     {ENV["CLIENT_ID"]}
  let(:client_secret) {ENV["CLIENT_SECRET"]}
  describe "#create" do
    context "sandbox" do
      before do
        SquareConnector.destroy_all
        get :create, params: {square_connector: {client_id: client_id, client_secret: client_secret}}
      end

      it "should successfully create SquareConnector" do
        expect(SquareConnector.count) == 1
      end

      it "should successfully create SquareConnector with access_token and other attributes" do
        connector = SquareConnector.last
        expect(connector.production).to be(false)
        expect(connector.host).to eq("https://connect.squareupsandbox.com")
        expect(response).to redirect_to "https://connect.squareupsandbox.com/oauth2/authorize?client_id=#{connector.client_id}&scope=ORDERS_WRITE%20ORDERS_READ%20BANK_ACCOUNTS_READ%20MERCHANT_PROFILE_READ%20PAYMENTS_READ%20SETTLEMENTS_READ%20CUSTOMERS_WRITE%20CUSTOMERS_READ%20INVOICES_READ%20INVOICES_WRITE"
      end
    end

    context "production" do
      before do
        SquareConnector.destroy_all
        get :create, params: {square_connector: {production: true, client_id: client_id, client_secret: client_secret}}
      end

      it "should successfully create SquareConnector with access_token and other attributes" do
        connector = SquareConnector.last
        expect(connector.production).to be(true)
        expect(connector.host).to eq("https://connect.squareup.com")
        expect(response).to redirect_to "https://connect.squareup.com/oauth2/authorize?client_id=#{connector.client_id}&scope=ORDERS_WRITE%20ORDERS_READ%20BANK_ACCOUNTS_READ%20MERCHANT_PROFILE_READ%20PAYMENTS_READ%20SETTLEMENTS_READ%20CUSTOMERS_WRITE%20CUSTOMERS_READ%20INVOICES_READ%20INVOICES_WRITE"
      end
    end
  end

  describe "#callback" do
    context "success with code" do
      before do
        SquareConnector.destroy_all
        @square_connector = SquareConnector.create({client_id: client_id, client_secret: client_secret})
        body_request =  {
          "client_id"=>client_id,
          "client_secret"=>client_secret,
          "code"=>"auth_code",
          "grant_type"=>"authorization_code"
        }.to_json

        headers_request = {:content_type=>"application/json", :square_version=>"2023-07-20"}

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
        expect(flash[:notice]).to eq("Square connector was successfully updated.")
        @square_connector.reload
        expect(@square_connector.access_token).to eq("access_token")
      end
    end

    context "failed without code" do
      before do
        SquareConnector.destroy_all
        @square_connector = SquareConnector.create({client_id: client_id, client_secret: client_secret})
        get :callback, params: {code: nil}
      end

      it "should redirect to square_connectors_path" do
        expect(response).to redirect_to square_connectors_path
        expect(flash[:notice]).to eq("Square connector creation failed!")
      end
    end
  end

  describe "#index" do
    before do
      SquareConnector.destroy_all
      SquareConnector.create()
      get :index
    end

    it "should successfully create SquareConnector" do
      expect(SquareConnector.count) == 1
    end
  end

  describe "#destroy" do
    before do
      SquareConnector.destroy_all
      @connector = SquareConnector.create({client_id: client_id, client_secret: client_secret})
      @connector.reload
      delete :destroy, params: {id: @connector.id}
    end 

    it "should successfully create SquareConnector" do
      expect(SquareConnector.count) == 0
    end
  end

  describe "#refresh_token" do
    before do 
      SquareConnector.destroy_all
      @connector = SquareConnector.create({client_id: client_id, client_secret: client_secret, access_token: "old_access_token", refresh_token: "refresh_token"})
      @old_access_token = @connector.access_token

      body_request =  {
        "client_id" => @connector.client_id,
        "client_secret" => @connector.client_secret,
        "grant_type"=> "refresh_token",
        "refresh_token" => "refresh_token",
      }.to_json
      headers_request = {:content_type=>"application/json", :square_version=>"2023-07-20"}
      
      body_response = {
        token_type: "bearer",
        refresh_token: "refresh_token",
        access_token: "new_access_token",
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

      get :refresh_token, params: {id: @connector.id}
    end

    it "should update access token" do
      expect(@old_access_token).to eq("old_access_token")
      expect(SquareConnector.last.access_token).to eq("new_access_token")
    end
  end
end

