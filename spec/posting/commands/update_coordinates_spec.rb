require "spec_helper"

describe Posting::Commands::UpdateCoordinates do
  subject { described_class.new(ads_repo: ads_repo, validation: validation) }

  let(:payload) { { post_id: 1, lat: "1", lon: "1" } }
  let(:ads_repo) { instance_double(Posting::Repositories::AdsRepo, update_by_id: 3) }
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
  end
end
