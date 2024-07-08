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
end