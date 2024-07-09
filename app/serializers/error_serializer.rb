class ErrorSerializer
  def initialize(error_object)
    @error_object = error_object
  end

  def error
    {
      error: [
        {
          message: @error_object.message,
          status: @error_object.status.to_s
        }
      ]
    }
  end
end