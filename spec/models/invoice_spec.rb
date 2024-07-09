require "rails_helper"

describe Invoice, type: :model do
  describe "relationships" do
    it { should belong_to :customer }
    it { should belong_to :merchant }
  end

  describe "validations" do
    it { should validate_presence_of :status }
  end
end