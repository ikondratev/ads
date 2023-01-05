require "application_helper"

describe Posting::Commands::CreatePost, type: :command do
  subject { described_class.new(validation: validation, geocoder_client: geocoder) }

  before do
    allow_any_instance_of(Sequel::Model).to receive(:save).and_return(save_result)
  end

  let(:save_result) { OpenStruct.new(id: 5) }
  let(:validation) { Validations::CreatePayload.new }
  let(:geocoder) { GeocoderService::Rpc::Client.new }

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

    context "in case of validation params error" do
      let(:payload) { { city: "city" } }

      it "should return falsy result" do
        result = subject.call(payload)
        expect { result }.not_to raise_error
        expect(result.success?).to be_falsey
      end
    end

    context "in case of create post error" do
      before do
        allow_any_instance_of(Sequel::Model).to receive(:save).and_raise(StandardError)
      end

      it "should return falsy result" do
        result = subject.call(payload)
        expect { result }.not_to raise_error
        expect(result.success?).to be_falsey
      end
    end

    context "in case of queue encode location error" do
      before do
        allow_any_instance_of(Sequel::Model).to receive(:save).and_return(create_result)
        allow_any_instance_of(GeocoderService::Rpc::Client).to receive(:geocoding).and_raise(StandardError)
      end

      let(:create_result) { OpenStruct.new(id: 7) }

      it "should return false result" do
        result = subject.call(payload)
        expect { result }.not_to raise_error
        expect(result.success?).to be_falsey
      end
    end
  end
end
