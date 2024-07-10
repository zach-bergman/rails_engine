require "rails_helper"

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
  end
  describe "relationships" do
    it { should have_many :items }
  end

  describe ".find_merchant_by_name" do
    before :each do
      @merchant1 = create(:merchant, name: "Kilback Inc")
      @merchant2 = create(:merchant, name: "Ring World")
      @merchant3 = create(:merchant, name: "Turing Inc")
      @merchant4 = create(:merchant, name: "Rings and Things")
    end

    it "returns the first merchant that matches the search term" do
      expect(Merchant.find_merchant_by_name("Ring")).to eq(@merchant2)
    end

    it "is case insensitive" do
      expect(Merchant.find_merchant_by_name("ring")).to eq(@merchant2)
    end

    it "returns nil if no merchant matches the fragment" do
      expect(Merchant.find_merchant_by_name("wrong_name")).to eq(nil)
    end

    it "returns the merchant even if partial match" do
      expect(Merchant.find_merchant_by_name("back")).to eq(@merchant1)
    end
  end
end