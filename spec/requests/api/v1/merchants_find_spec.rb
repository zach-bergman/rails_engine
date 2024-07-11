require "rails_helper"

RSpec.describe "Merchants Find API" do
  describe "/api/v1/merchants/find" do
    it "can find a merchant by its name(happy)" do
      merchant1 = create(:merchant, name: "Kilback Inc")
      merchant2 = create(:merchant, name: "Ring World")
      merchant3 = create(:merchant, name: "Turing Inc")
      merchant4 = create(:merchant, name: "Rings and Things")

      get "/api/v1/merchants/find?name=back"

      expect(response).to be_successful
      expect(response.status).to eq(200)
      
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:data][:attributes][:name]).to eq(merchant1.name)
    end

    it "can find a merchant by its name(sad)" do
      get "/api/v1/merchants/find?name=wrong_name", headers: headers
      
      expect(response).not_to be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data).to have_key(:data)
      expect(data[:data]).to be_a(Hash)
      expect(data[:data]).to eq({})
    end

    it "can find a merchant by its name(sad) - name must be entered" do
      get "/api/v1/merchants/find?name=", headers: headers

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      data = JSON.parse(response.body, symbolize_names: true)[:errors].first

      expect(data[:title]).to eq("Name parameter is required")
      expect(data[:status]).to eq(400)
    end
  end
end