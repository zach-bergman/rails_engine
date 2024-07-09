require "rails_helper"

RSpec.describe ErrorMessage do
  it "exists" do
    message = "Error"
    status = 400
    error = ErrorMessage.new(message, status)

    expect(error).to be_a(ErrorMessage)
    expect(error.message).to eq(message)
    expect(error.status).to eq(status)
  end
end