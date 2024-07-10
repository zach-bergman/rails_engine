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
      render json: { error: 'Name parameter is required' }, status: :bad_request
    end
  end
end