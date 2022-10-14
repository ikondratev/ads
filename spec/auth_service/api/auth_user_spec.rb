require "spec_helper"

describe AuthService::API::AuthUser, type: :lib_action do
  subject { described_class.new(connection: connection, base_url: url ) }

  let(:connection) { Faraday::Connection.new }
  let(:token) { "token" }
  let(:url) { "http://localhost" }

  describe "#call" do
    context "without any errors" do
      before do
        allow_any_instance_of(Faraday::Connection).to receive(:post).and_return(Faraday::Response.new)
        allow_any_instance_of(Faraday::Response).to receive(:success?).and_return(true)
        allow_any_instance_of(Faraday::Response).to receive(:body).and_return(body)
      end

      let(:body) do
        {
          meta: {
            user_id: 1
          }
        }
      end

      it "should return valid result" do
        result = subject.call(token)
        expect{ result }.not_to raise_error
        expect(result.success?).to be(true)
        expect(result.success[:user_id]).to be(1)
      end
    end

    context "when user unauthorised" do
      before do
        allow_any_instance_of(Faraday::Connection).to receive(:post).and_return(Faraday::Response.new)
        allow_any_instance_of(Faraday::Response).to receive(:success?).and_return(false)
      end

      it "should return error result" do
        result = subject.call(token)
        expect(result.success?).to be(false)
        expect(result.failure[0]).to be(:bad_request)
      end
    end
  end
end
