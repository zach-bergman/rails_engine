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
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq(400)
      expect(data[:errors].first[:title]).to eq("Validation failed: Description can't be blank")
    end
  end

  describe "update item /api/v1/items/:id" do
    it "can update an existing item (happy)" do
      item = create(:item)
      previuos_name = Item.last.name
      item_params = ({
        name: "New Item",
        description: "New Description",
        unit_price: 10.99,
        merchant_id: create(:merchant).id
      })

      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      updated_item = Item.find_by(id: item.id)

      expect(updated_item.name).to_not eq(previuos_name)
      expect(updated_item.name).to eq("New Item")
    end

    it "can update an existing item (sad)" do
      item = create(:item)
      item_params = ({
        name: "New Item",
        description: "",
        unit_price: 10.99,
        merchant_id: create(:merchant).id
      })

      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq(400)
      expect(data[:errors].first[:title]).to eq("Validation failed: Description can't be blank")
    end

    it "can update an existing item (sad)" do
      item = create(:item)
      item_params = ({
        name: "New Item",
        description: "",
        unit_price: 10.99,
        merchant_id: create(:merchant).id
      })

      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/18181717181", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq(404)
      expect(data[:errors].first[:title]).to eq("Couldn't find Item with 'id'=18181717181")
    end
  end

  describe "delete item /api/v1/items/:id" do
    it "can delete an existing item(happy)" do
      item = create(:item)
      invoice = create(:invoice)
      InvoiceItem.create!(item: item, invoice: invoice, quantity: 1, unit_price: 10.99)
      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item.id}"
      expect(response).to be_successful
      expect(response.status).to eq(204)

      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "can delete an existing item(sad)" do
      delete "/api/v1/items/18181717181"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq(404)
      expect(data[:errors].first[:title]).to eq("Couldn't find Item with 'id'=18181717181")
    end

  end

  describe "/api/v1/items/:id/merchant" do
    it "can get the merchant data for a given item ID" do
      item = create(:item)
      merchant = item.merchant
      
      get "/api/v1/items/#{item.id}/merchant"
      
      merchant_json = JSON.parse(response.body, symbolize_names: true)
      
      merchant_data = merchant_json[:data]
      
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

  describe "/api/v1/items/find_all" do
    it "can find all items that match a search by name" do
      item_1 = create(:item, name: "Red Shirt")
      item_2 = create(:item, name: "White Shirt")
      item_3 = create(:item, name: "Grey Pants")
      item_4 = create(:item, name: "Black Pants")

      get "/api/v1/items/find_all?name=shirt"
      
      expect(response).to be_successful
      expect(response.status).to eq(200)

      items_json = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items_json).to be_an(Array)
      expect(items_json.count).to eq(2)

      expect(items_json[0][:attributes][:name]).to eq(item_1.name)
      expect(items_json[1][:attributes][:name]).to eq(item_2.name)
    end
  end
end