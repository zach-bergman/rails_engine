class Api::V1::Items::SearchController < ApplicationController
  def index
    if search_params[:name] && search_params[:name].empty?
      error_message = "No name entered"
      render json: ErrorSerializer.new(ErrorMessage.new(error_message, 400)).serialize_json, status: 400

    elsif search_params[:name] && (search_params[:min_price] || search_params[:max_price])
      error_message = "Cannot search by name and price at the same time"
      render json: ErrorSerializer.new(ErrorMessage.new(error_message, 400)).serialize_json, status: 400

    elsif search_params[:name]
      items = Item.find_all_by_name(search_params[:name])
      render json: ItemSerializer.new(items)

    elsif search_params[:min_price].to_i < 0 || search_params[:max_price].to_i < 0
      error_message = "Price cannot be less than 0"
      render json: ErrorSerializer.new(ErrorMessage.new(error_message, 400)).serialize_json, status: 400

    elsif search_params[:min_price] && search_params[:max_price] && search_params[:min_price] > search_params[:max_price]
      error_message = "Minimum price cannot be greater than maximum price"
      render json: ErrorSerializer.new(ErrorMessage.new(error_message, 400)).serialize_json, status: 400

    elsif search_params[:min_price] && search_params[:max_price]
      items = Item.find_all_by_price_range(search_params[:min_price], search_params[:max_price])
      render json: ItemSerializer.new(items)

    elsif search_params[:min_price]
      items = Item.find_all_by_min_price(search_params[:min_price])
      render json: ItemSerializer.new(items)

    elsif search_params[:max_price]
      items = Item.find_all_by_max_price(search_params[:max_price])
      render json: ItemSerializer.new(items)

    else 
      error_message = "No search parameters entered"
      render json: ErrorSerializer.new(ErrorMessage.new(error_message, 400)).serialize_json, status: 400
    end
  end

  private

  def search_params
    params.permit(:id, :name, :description, :unit_price, :merchant_id, :created_at, 
    :updated_at, :min_price, :max_price)
  end
end