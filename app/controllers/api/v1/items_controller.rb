class Api::V1::ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :missing_attributes
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    render json: ItemSerializer.new(Item.create!(item_params)), status: 201
  end

  def update
    render json: ItemSerializer.new(Item.update!(params[:id], item_params)), status: 200
  end

  def destroy
    @deleted_item = Item.find(params[:id])
    @deleted_item.invoice_items.each { |item| item.destroy }
    render json: Item.delete(@deleted_item), status: 204
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def missing_attributes(execution)
    render json: ErrorSerializer.new(ErrorMessage.new(execution.message, 400)).serialize_json, status: 400
  end

  def not_found(execution)
    render json: ErrorSerializer.new(ErrorMessage.new(execution.message, 404)).serialize_json, status: 404
  end
end