require "application_helper"

describe Posting::Commands::CreatePost, type: :command do
  subject { described_class.new(validation: validation, geocoder_client: geocoder) }

  before do
    FactoryBot.create(:ads)
  end

  let(:validation) { Validations::CreatePayload.new }
  let(:geocoder) { instance_double(GeocoderService::Rpc::Client, geocoding: Success()) }

  let(:success_geocoder_response) do
    {
      "lat" => "test_lat",
      "lon" => "test_lon"
    }
  end

  let(:payload) do
    {
      city: "city",
      description: "description",
      user_id: 1,
      title: "string"
    }
  end


  describe "#call" do
    context "without any errors" do
      it "shouldn't raise any errors" do
        result = subject.call(payload)
        expect{ result }.not_to raise_error
        expect(result).to be_success
      end
    end
  end
end
