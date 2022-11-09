require "spec_helper"

describe GeocoderService::HTTP::API::EncodeLocation, type: :third_parties do
  subject { described_class.new(connection: connection, base_url: url ) }

  let(:connection) { Faraday::Connection.new }
  let(:city) { "NewYork" }
  let(:url) { "http://localhost.ru" }

  describe "#call" do
    context "without any errors" do
      before do
        allow_any_instance_of(Faraday::Connection).to receive(:post).and_return(Faraday::Response.new)
        allow_any_instance_of(Faraday::Response).to receive(:success?).and_return(true)
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

      it "should return valid result" do
        result = subject.call(city)
        expect{ result }.not_to raise_error
        expect(result.success?).to be(true)
        expect(result.success).to be_kind_of(Hash)
        expect(result.success["lat"]).not_to be_nil
        expect(result.success["lon"]).not_to be_nil
      end
    end

    context "when geocoder had fail response" do
      before do
        allow_any_instance_of(Faraday::Connection).to receive(:post).and_return(Faraday::Response.new)
        allow_any_instance_of(Faraday::Response).to receive(:success?).and_return(false)
      end

      it "should return error result" do
        result = subject.call(city)
        expect(result.success?).to be(false)
        expect(result.failure[0]).to be(:bad_request)
      end
    end

    context "when geocoder had empty response" do
      before do
        allow_any_instance_of(Faraday::Connection).to receive(:post).and_return(Faraday::Response.new)
        allow_any_instance_of(Faraday::Response).to receive(:success?).and_return(true)
        allow_any_instance_of(Faraday::Response).to receive(:body).and_return(body)
      end

      let(:body) do
        {
          meta: {
            encode: [nil, "lon"]
          }
        }
      end

      it "should return error result" do
        result = subject.call(city)
        expect(result.success?).to be(false)
        expect(result.failure[0]).to be(:empty_response)
      end
    end
  end
end
