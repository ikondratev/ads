require "spec_helper"

RSpec.describe Posting::Commands::CreatePost, type: :command do
  subject { command.call(payload) }

  let(:command) { described_class.new(ads_repo: ads_repo, validation: validation, location: geocoder ) }
  let(:ads_repo) { instance_double(Posting::Repositories::AdsRepo, create: 3) }
  let(:validation) { Validations::CreatePayload.new }
  let(:geocoder) { instance_double(GeocoderService::API::EncodeLocation, call: Success(["ne_lat", "ne_lon"])) }

  let(:payload) do
    {
      city: "city",
      description: "description",
      user_id: 1,
      title: "string"
    }
  end


  context "without any errors" do
    it "shouldn't raise any errors" do
      expect{ subject }.not_to raise_error
      expect(subject).to be_success
    end
  end

  context "in case of error" do
    before do
      allow_any_instance_of(Posting::Repositories::AdsRepo).to receive(:create).and_raise(StandardError)
    end

    let(:ads_repo) { Posting::Repositories::AdsRepo.new }

    it "should raise :creation_error" do
      expect(subject).to be_failure
      expect(subject.failure).to eq([:creation_error])
    end
  end

  context "in case of location encoder error" do
    let(:geocoder) { instance_double(GeocoderService::API::EncodeLocation, call: Failure([:encode_error])) }

    it "should raise :encode_location_error" do
      expect(subject).to be_failure
      expect(subject.failure).to eq([:encode_location_error])
    end
  end
end
