require "rails_helper"

describe "Items API" do
  describe "/api/v1/items" do
    it "sends a list of items" do
      create_list(:item, 3)

      get "/api/v1/items"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items_json = JSON.parse(response.body, symbolize_names: true)

      items = items_json[:data]

      expect(items.count).to eq(3)
      expect(items).to be_an(Array)

      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)

        expect(item).to have_key(:type)
        expect(item[:type]).to be_an(String)

        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_a(Hash)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end
  end

  describe "/api/v1/items/:id" do
    it "can get one item by its id" do
      id = create(:item).id

      get "/api/v1/items/#{id}"

      item_json = JSON.parse(response.body, symbolize_names: true)

      item = item_json[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to be_an(String)

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  describe "/api/v1/items/:id/merchant" do
    it "can get the merchant data for a given item ID" do
      item = create(:item)
      merchant = item.merchant
      
      get "/api/v1/items/#{item.id}/merchant"
      
      merchant_json = JSON.parse(response.body, symbolize_names: true)
      
      merchant_data = merchant_json[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(merchant_data).to have_key(:id)
      expect(merchant_data[:id]).to be_an(String)

      expect(merchant_data).to have_key(:type)
      expect(merchant_data[:type]).to be_an(String)

      expect(merchant_data).to have_key(:attributes)
      expect(merchant_data[:attributes]).to be_a(Hash)
      expect(merchant_data[:attributes]).to have_key(:name)
      expect(merchant_data[:attributes][:name]).to be_a(String)
    end

    it "returns a 404 if the item does not exist" do
      get "/api/v1/items/1/merchant"
      
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      items_json = JSON.parse(response.body, symbolize_names: true)

      expect(items_json[:errors]).to be_a(Array)
      expect(items_json[:errors].first[:title]).to eq("Couldn't find Item with 'id'=1")
      expect(items_json[:errors].first[:status]).to eq(404)
    end
  end
end