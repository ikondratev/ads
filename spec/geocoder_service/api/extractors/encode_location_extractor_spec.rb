require "spec_helper"

describe GeocoderService::API::Extractors::EncodeLocationExtractor do
  subject { described_class.new }

  let(:response) { Faraday::Response.new }

  describe "#call" do
    context "without any errors" do
      before do
        allow_any_instance_of(Faraday::Response).to receive(:body).and_return(body)
      end

      let(:body) do
        {
          "meta" => {
            "encode" => {
              "lat" => "test_lat",
              "lon" => "test_lon"
            }
          }
        }
      end

      it "should return valide result" do
        result = subject.call(response)
        expect{ result }.not_to raise_error
      end
    end

    context "in case of one of elements was empty" do
      before do
        allow_any_instance_of(Faraday::Response).to receive(:body).and_return({})
      end

      let(:body) do
        {
          "meta" => {
            "encode" => {
              "lat" => "test_lat",
              "lon" => nil
            }
          }
        }
      end

      it "should raise ExtractorError" do
        expect{ subject.call(response) }.to raise_error(GeocoderService::API::Extractors::ExtractorError)
      end
    end

    context "in case of one of elements was empty" do
      before do
        allow_any_instance_of(Faraday::Response).to receive(:body).and_return(nil)
      end

      it "should raise ExtractorError" do
        expect{ subject.call(response) }.to raise_error(GeocoderService::API::Extractors::ExtractorError)
      end
    end
  end
end
