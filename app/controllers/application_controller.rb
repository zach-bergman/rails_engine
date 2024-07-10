class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :missing_attributes

  private

  def record_not_found(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
    .serialize_json, status: 404
  end

  def missing_attributes(execution)
    render json: ErrorSerializer.new(ErrorMessage.new(execution.message, 400)).serialize_json, status: 400
  end
end