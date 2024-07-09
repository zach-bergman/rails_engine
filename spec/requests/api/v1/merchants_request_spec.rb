require "rails_helper"

describe "Merchants API" do
  describe "/api/v1/merchants" do
    it "sends a list of merchants" do
      create_list(:merchant, 3)

      get "/api/v1/merchants"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants_json = JSON.parse(response.body, symbolize_names: true)

      merchants = merchants_json[:data]

      expect(merchants.count).to eq(3)
      expect(merchants).to be_an(Array)

      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(String)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
  end

  describe "/api/v1/merchants/:id" do
    it "can get one merchant by its id" do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"

      merchant_json = JSON.parse(response.body, symbolize_names: true)

      merchant = merchant_json[:data]
      
      expect(response).to be_successful
      expect(response.status).to eq(200)
      
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)
      
      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_an(String)
      
      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end
  
  describe "/api/v1/merchants/:id/items" do
    it "can get all items for a merchant by its id" do
      merchant = create(:merchant)
      create_list(:item, 3, merchant: merchant)
      
      get "/api/v1/merchants/#{merchant.id}/items"
      
      items_json = JSON.parse(response.body, symbolize_names: true)
      
      items = items_json[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

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
        expect(item[:attributes][:merchant_id]).to eq(merchant.id)
      end
    end

    it "returns a 404 if the merchant does not exist" do
      get "/api/v1/merchants/1/items"
      
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      items_json = JSON.parse(response.body, symbolize_names: true)

      expect(items_json[:errors]).to be_a(Array)
      expect(items_json[:errors].first[:title]).to eq("Couldn't find Merchant with 'id'=1")
      expect(items_json[:errors].first[:status]).to eq(404)
    end
  end
end