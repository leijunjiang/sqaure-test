class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]
  before_action :find_connector, only: %i[index]

  def index
    return @orders = nil if params[:date].blank?

    p "@square_connector == "
    p @square_connector
    p "access_token ==="
    p @square_connector&.access_token

    location_id, @name = LocationIdFetcherService.new(@square_connector).location_id
    date = params[:date]

    @orders, @error_message= OrderService.new(@square_connector, {location_id: location_id, date: date}).call
    if @orders
      p 'orders === '
      p @orders
      order_parser = OrderParser.new(@orders)
      @revenue_categories = order_parser.revenue_categories
      @revenue =  @revenue_categories.inject(0) {|sum, r| sum += r[1]}
      @taxes = order_parser.taxes
      @tips = order_parser.tips
      @liabilities = order_parser.liabilities
    end

    invoices = InvoiceService.new(@square_connector, {location_id: location_id, date: date}).call
    if invoices
      p "invoices ==== "
      p invoices
      @assets = InvoiceParser.new(invoices, date).assets
    end

    payments = PaymentService.new(@square_connector, {date: date}).call
    if payments
      p "payments ==== "
      p payments
      payment_parser = PaymentParser.new(payments)
      @payment_processors = payment_parser.payment_processors
      @adjustments = payment_parser.adjustments
    end

    @balanced = BalanceCalculator.new(@revenue, @tips, @liabilities, @assets, @adjustments).calculate

  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to order_url(@order), notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    def find_connector
      @square_connector = SquareConnector.last
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.fetch(:order, {})
    end
end
