class Api::V1::Items::SearchController < ApplicationController
  def index
    items = Item.find_all_by_name(search_params[:name]) if search_params[:name]
    render json: ItemSerializer.new(items)
  end

  private

  def search_params
    params.permit(:id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
  end
end