require "rails_helper"

describe Item, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
  end

  it { should validate_presence_of :name }
  it { should validate_presence_of :description }
  it { should validate_presence_of :unit_price }
  it { should validate_presence_of :merchant_id }

  describe "class methods" do
    describe ".find_all_by_name" do
      it "returns all items with a name that contains the search term" do
        merchant = create(:merchant)
        item_1 = create(:item, name: "Red Shirt")
        item_2 = create(:item, name: "White Shirt")
        item_3 = create(:item, name: "Grey Pants")
        item_4 = create(:item, name: "Black Pants")
        item_5 = create(:item, name: "Super Soaker")
        item_6 = create(:item, name: "Water Balloon")
        item_7 = create(:item, name: "Water Slide")

        expect(Item.find_all_by_name("shirt")).to eq([item_1, item_2])
        expect(Item.find_all_by_name("pants")).to eq([item_3, item_4])
        expect(Item.find_all_by_name("water")).to eq([item_6, item_7])
      end
    end
  end
end