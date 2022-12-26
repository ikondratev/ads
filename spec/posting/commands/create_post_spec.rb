require "application_helper"

describe Posting::Commands::CreatePost, type: :command do
  subject { described_class.new(validation: validation, geocoder_client: geocoder) }

  before do
    allow_any_instance_of(Sequel::Model).to receive(:save).and_return(save_result)
  end

  let(:save_result) { OpenStruct.new(id: 5) }
  let(:validation) { Validations::CreatePayload.new }
  let(:geocoder) { instance_double(GeocoderService::Rpc::Client, geocoding: Success()) }

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
