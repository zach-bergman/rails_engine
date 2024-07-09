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

  describe "create item /api/v1/items" do
    it "can create a new item (happy)" do
      item_params = ({
        name: "New Item",
        description: "New Description",
        unit_price: 10.99,
        merchant_id: create(:merchant).id
      })

      headers = {"CONTENT_TYPE" => "application/json"}
    
      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      created_item = Item.last

      expect(response).to be_successful
      expect(response.status).to eq(201)

      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end

    it "can create a new item (sad)" do
      item_params = ({
        name: "New Item",
        unit_price: 10.99,
        merchant_id: create(:merchant).id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      
      data = JSON.parse(response.body, symbolize_names: true) 
      expect(data[:error]).to be_a(Array)
      expect(data[:error].first[:status]).to eq("400")
      expect(data[:error].first[:message]).to eq("Validation failed: Description can't be blank")
    end
  end
end