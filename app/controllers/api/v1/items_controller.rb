class Api::V1::ItemsController < ApplicationController
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
end