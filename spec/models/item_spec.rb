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

    describe ".find_all_by_min_price" do
      it "returns all items with a unit price greater than or equal to the search term" do
        item_1 = create(:item, unit_price: 10.99)
        item_2 = create(:item, unit_price: 12.99)
        item_3 = create(:item, unit_price: 14.99)
        item_4 = create(:item, unit_price: 16.99)

        expect(Item.find_all_by_min_price(12.99)).to eq([item_2, item_3, item_4])
        expect(Item.find_all_by_min_price(14.99)).to eq([item_3, item_4])
        expect(Item.find_all_by_min_price(16.99)).to eq([item_4])
        expect(Item.find_all_by_min_price(17.99)).to eq([])
      end
    end

    describe ".find_all_by_max_price" do
      it "returns all items with a unit price less than or equal to the search term" do
        item_1 = create(:item, unit_price: 10.99)
        item_2 = create(:item, unit_price: 12.99)
        item_3 = create(:item, unit_price: 14.99)
        item_4 = create(:item, unit_price: 16.99)

        expect(Item.find_all_by_max_price(12.99)).to eq([item_1, item_2])
        expect(Item.find_all_by_max_price(14.99)).to eq([item_1, item_2, item_3])
        expect(Item.find_all_by_max_price(16.99)).to eq([item_1, item_2, item_3, item_4])
        expect(Item.find_all_by_max_price(1.00)).to eq([])
      end
    end

    describe ".find_all_by_price_range" do
      it "returns all items with a unit price within the search term range" do
        item_1 = create(:item, unit_price: 10.99)
        item_2 = create(:item, unit_price: 12.99)
        item_3 = create(:item, unit_price: 14.99)
        item_4 = create(:item, unit_price: 16.99)

        expect(Item.find_all_by_price_range(10.99, 14.99)).to eq([item_1, item_2, item_3])
        expect(Item.find_all_by_price_range(12.99, 16.99)).to eq([item_2, item_3, item_4])
        expect(Item.find_all_by_price_range(14.99, 16.99)).to eq([item_3, item_4])
      end
    end
  end
end