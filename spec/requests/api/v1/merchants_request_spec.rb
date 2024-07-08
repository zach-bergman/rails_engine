require "rails_helper"

describe "Merchants API" do
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