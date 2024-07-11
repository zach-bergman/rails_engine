class Api::V1::MerchantsFindController < ApplicationController
  def index
    if params[:name].present?
      merchant = Merchant.find_merchant_by_name(params[:name])
      if merchant
        render json: MerchantSerializer.new(merchant)
      else
        render json: { data: {} }, status: :not_found
      end
    else
      render json: ErrorSerializer.new(ErrorMessage.new('Name parameter is required', 400)).serialize_json, status: 400
    end
  end
end