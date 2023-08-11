class SquareConnectorsController < ApplicationController
  before_action :set_square_connector, only: %i[ show edit update destroy ]
  before_action :find_square_connector, only: %i[callback refresh_token]
  def index
    @square_connectors = SquareConnector.all
  end

  def show
  end

  def new
    @square_connector = SquareConnector.new
  end

  def edit

  end

  def create
    @square_connector = SquareConnector.new(square_connector_params)
    respond_to do |format|
      if @square_connector.save
        scope_path = %w(
          BANK_ACCOUNTS_READ
          APPOINTMENTS_WRITE
          APPOINTMENTS_ALL_WRITE
          APPOINTMENTS_READ
          APPOINTMENTS_BUSINESS_SETTINGS_READ
          PAYMENTS_READ
          PAYMENTS_WRITE
          CASH_DRAWER_READ
          ITEMS_WRITE
          ITEMS_READ
          ORDERS_WRITE
          ORDERS_READ
          CUSTOMERS_WRITE
          CUSTOMERS_READ
          DEVICE_CREDENTIAL_MANAGEMENT
          DISPUTES_WRITE
          DISPUTES_READ
          EMPLOYEES_READ
          GIFTCARDS_READ
          GIFTCARDS_WRITE
          INVENTORY_WRITE
          INVENTORY_READ
          INVOICES_WRITE
          INVOICES_READ
          TIMECARDS_SETTINGS_WRITE
          TIMECARDS_WRITE
          TIMECARDS_SETTINGS_READ
          MERCHANT_PROFILE_WRITE
          MERCHANT_PROFILE_READ
          LOYALTY_READ
          LOYALTY_WRITE
          PAYMENTS_WRITE_IN_PERSON
          SETTLEMENTS_READ
          PAYMENTS_WRITE_SHARED_ONFILE
          PAYMENTS_WRITE_ADDITIONAL_RECIPIENTS
          PAYOUTS_READ
        ).join("%20")

        format.html { redirect_to "#{@square_connector.host}/oauth2/authorize?client_id=#{@square_connector.client_id}&scope=#{scope_path}"}
        format.json { render :show, status: :created, location: @square_connector }
      end
    end
  end

  # DELETE /square_connectors/1 or /square_connectors/1.json
  def destroy
    @square_connector.destroy

    respond_to do |format|
      format.html { redirect_to square_connectors_url, notice: "Square connector was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def callback
    authorization_code = params['code']
    if authorization_code.present?
      SquareObtainTokenService.new(@square_connector, authorization_code: authorization_code).call
      respond_to do |format|
        format.html { redirect_to orders_path, notice: "Square connector was successfully updated." }
      end
    else
      respond_to do |format|
        format.html { redirect_to square_connectors_path, notice: "Square connector creation failed!" }
      end
    end
  end

  def refresh_token
    SquareRefreshTokenService.new(@square_connector).call
    respond_to do |format|
      format.html { redirect_to orders_path, notice: "Square connector was successfully refreshed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_square_connector
      @square_connector = SquareConnector.find(params[:id])
    end

    def find_square_connector
      @square_connector = SquareConnector.last
    end

    # Only allow a list of trusted parameters through.
    def square_connector_params
      params.require(:square_connector).permit(:client_id, :client_secret, :production)
    end
end
