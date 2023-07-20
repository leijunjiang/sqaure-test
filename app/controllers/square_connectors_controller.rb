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
        format.html { redirect_to "https://connect.squareupsandbox.com/oauth2/authorize?client_id=#{@square_connector.client_id}&scope=ORDERS_WRITE%20ORDERS_READ%20BANK_ACCOUNTS_READ%20MERCHANT_PROFILE_READ%20PAYMENTS_READ%20SETTLEMENTS_READ%20CUSTOMERS_WRITE%20CUSTOMERS_READ%20INVOICES_READ%20INVOICES_WRITE"}
        format.json { render :show, status: :created, location: @square_connector }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @square_connector.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /square_connectors/1 or /square_connectors/1.json
  def update
    respond_to do |format|
      if @square_connector.update(square_connector_params)
        format.html { redirect_to square_connector_url(@square_connector), notice: "Square connector was successfully updated." }
        format.json { render :show, status: :ok, location: @square_connector }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @square_connector.errors, status: :unprocessable_entity }
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

    if authorization_code
      SquareObtainTokenService.new(@square_connector, authorization_code: authorization_code).call
      respond_to do |format|
        format.html { redirect_to square_connectors_path, notice: "Square connector was successfully updated." }
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
      format.html { redirect_to square_connectors_path, notice: "Square connector was successfully refreshed." }
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
