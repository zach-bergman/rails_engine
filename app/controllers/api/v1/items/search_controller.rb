class Api::V1::Items::SearchController < ApplicationController
  def index
    if search_params[:name]
      items = Item.find_all_by_name(search_params[:name])
      render json: ItemSerializer.new(items)
    elsif search_params[:min_price]
      items = Item.find_all_by_min_price(search_params[:min_price])
      render json: ItemSerializer.new(items)
    elsif search_params[:max_price]
      items = Item.find_all_by_max_price(search_params[:max_price])
      render json: ItemSerializer.new(items)
    end
  end

  private

  def search_params
    params.permit(:id, :name, :description, :unit_price, :merchant_id, :created_at, 
    :updated_at, :min_price, :max_price)
  end
end