require "application_helper"

describe GeocoderService::HTTP::API::EncodeLocation, type: :client do
  subject { described_class.new(connection: connection ) }

  before do
    stubs.post("http://localhost:3005/geocoder/v1/") { [status, headers, body.to_json] }
  end

  let(:status) { 200 }
  let(:headers) { { "Content-Type" => "application/json" } }
  let(:body) { {"meta" => {"encode" => { "lat" => 2.3, "lon" => 3.2 }}} }
  let(:city) { "NewYork" }

  describe "#call" do
    context "without any errors" do
      it "should return valid result" do
        result = subject.call(city)
        expect { result }.not_to raise_error
        expect(result.success?).to be_truthy
      end
    end

    context "in case of validation error" do
      let(:city) { 123 }

      it "should return falsey result" do
        result = subject.call(city)
        expect { result }.not_to raise_error
        expect(result.success?).to be_falsey
      end
    end

    context "in case of bad request" do
      let(:status) { 503 }

      it "should return falsey result" do
        result = subject.call(city)
        expect { result }.not_to raise_error
        expect(result.success?).to be_falsey
      end
    end

    context "in case of extractor error" do
      before do
        allow_any_instance_of(GeocoderService::HTTP::API::Extractors::EncodeLocationExtractor).to receive(:call).and_raise(GeocoderService::HTTP::API::Extractors::ExtractorError)
      end

      it "should return falsey result" do
        result = subject.call(city)
        expect { result }.not_to raise_error
        expect(result.success?).to be_falsey
      end
    end
  end
end
