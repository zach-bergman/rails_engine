class ErrorSerializer
  def initialize(error_object)
    @error_object = error_object
  end
  
  def serialize_json
    {
      errors: [
        {
          status: @error_object.status,
          title: @error_object.message
        }
      ]
    }
  end
end