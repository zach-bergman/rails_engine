class Api::V1::ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :missing_attributes
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    render json: ItemSerializer.new(Item.create!(item_params)), status: 201
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def missing_attributes(execution)
    render json: ErrorSerializer.new(ErrorMessage.new(execution.message, 400)).error, status: 400
  end
end