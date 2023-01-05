require "application_helper"

describe AuthService::HTTP::Client, type: :client do
  subject { described_class.new(connection: connection ) }

  before do
    stubs.post("http://localhost:3003/auth/v1/") { [status, headers, body.to_json] }
  end

  let(:status) { 200 }
  let(:headers) { { "Content-Type" => "application/json" } }
  let(:body) {{ "meta" => { "user_id" => 1 }}}
  let(:token) { "token" }

  describe "#auth" do
    context "without any errors" do
      it "should return valid result" do
        result = subject.auth(token)
        expect { result }.not_to raise_error
        expect(result.success?).to be_truthy
        expect(result.success[:user_id]).to be(1)
      end
    end
  end
end
