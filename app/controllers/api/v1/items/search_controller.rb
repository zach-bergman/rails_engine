class Api::V1::Items::SearchController < ApplicationController
  def index
    if invalid_name_search?
      render_error("No name entered", 400)
    elsif conflicting_search_params?
      render_error("Cannot search by name and price at the same time", 400)
    elsif search_params[:name]
      render_items(Item.find_all_by_name(search_params[:name]))
    elsif invalid_price_range?
      render_error("Price cannot be less than 0", 400)
    elsif min_price_greater_than_max?
      render_error("Minimum price cannot be greater than maximum price", 400)
    elsif search_params[:min_price] && search_params[:max_price]
      render_items(Item.find_all_by_price_range(search_params[:min_price], search_params[:max_price]))
    elsif search_params[:min_price]
      render_items(Item.find_all_by_min_price(search_params[:min_price]))
    elsif search_params[:max_price]
      render_items(Item.find_all_by_max_price(search_params[:max_price]))
    else 
      render_error("No search parameters entered", 400)
    end
  end

  private

  def search_params
    params.permit(:id, :name, :description, :unit_price, :merchant_id, :created_at, 
    :updated_at, :min_price, :max_price)
  end

  def render_error(message, status)
    render json: ErrorSerializer.new(ErrorMessage.new(message, status)).serialize_json, status: status
  end

  def render_items(items)
    render json: ItemSerializer.new(items)
  end

  def invalid_name_search?
    search_params[:name] && search_params[:name].empty?
  end

  def conflicting_search_params?
    search_params[:name] && (search_params[:min_price] || search_params[:max_price])
  end

  def invalid_price_range?
    search_params[:min_price].to_i < 0 || search_params[:max_price].to_i < 0
  end

  def min_price_greater_than_max?
    search_params[:min_price] && search_params[:max_price] && search_params[:min_price] > search_params[:max_price]
  end
end