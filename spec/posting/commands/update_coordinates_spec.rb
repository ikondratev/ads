require "application_helper"

describe Posting::Commands::UpdateCoordinates do
  subject { described_class.new(validation: validation) }

  before do
    allow(Sequel::Model).to receive(:find).and_return(ad)
  end

  let(:ad) { instance_double(Posting::Models::Ad, update_fields: true) }
  let(:payload) { { post_id: 1, lat: 0.123, lon: 0.125 } }
  let(:validation) { Validations::UpdateCoordinates.new }

  describe "#call" do
    context "without any errors" do
      it "should return valid result" do
        result = subject.call(payload)
        expect { result }.not_to raise_error
        expect(result.success?).to be_truthy
      end
    end

    context "in case of invalid params" do
      let(:payload) { { post_id: 1, lat: 1, lon: "1" }  }
      it "should return false result" do
        result = subject.call(payload)
        expect { result }.not_to raise_error
        expect(result.success?).to be_falsey
        expect(result.failure[0]).to be(:invalid_payload)
      end
    end

    context "in case of error" do
      before do
        allow(Sequel::Model).to receive(:find).and_raise(StandardError)
      end

      it "should return falsey result" do
        result = subject.call(payload)
        expect { result }.not_to raise_error
        expect(result.success?).to be_falsey
      end
    end
  end
end
