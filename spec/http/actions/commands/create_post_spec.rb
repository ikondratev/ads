require "spec_helper"

RSpec.describe HTTP::Actions::Commands::CreatePost, type: :http_action do
  before do
    allow_any_instance_of(AuthService::Client).to receive(:auth).and_return(Success({ user_id: 1 }))
  end

  subject { described_class.new(command: command) }

  let(:command) { ->(*) { Success(:done) } }
  let(:env_params) do
    {
      "HTTP_BEARER" => "123-123-123",
      "title" => "Test title",
      "city" => "City",
      "description" => "Description",
    }
  end

  context "when command complete business logic correct" do
    let(:command) { ->(*) { Success(:done) } }

    it "should returns valid result" do
      result = subject.call(env_params)
      expect(result.status).to eq(201)
    end
  end

  context "when user authenticate with error" do
    before do
      allow_any_instance_of(AuthService::Client).to receive(:auth).and_return(Failure([:bad_request]))
    end

    let(:expected_result_body) do
      [{
        "error_message": "Ресурс не найден"
      }.to_json]
    end

    it "should return error result" do
      result = subject.call(env_params)
      expect(result.status).to be(404)
      expect(result.body).to eq(expected_result_body)
    end
  end

  context "when command returned error" do
    let(:command) { ->(*) { Failure([:creation_error]) } }

    let(:expected_result_body) do
      [{
         "error_message": "Публикация не была создана"
       }.to_json]
    end

    it "should return error result" do
      result = subject.call(env_params)
      expect(result.status).to be(503)
      expect(result.body).to eq(expected_result_body)
    end
  end
end