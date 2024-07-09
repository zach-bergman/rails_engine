class Api::V1::Merchants::ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
  end

  private

  def record_not_found(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
    .serialize_json, status: 404
  end
end