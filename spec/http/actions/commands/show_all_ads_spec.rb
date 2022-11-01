require "spec_helper"

describe HTTP::Actions::Commands::ShowAllAds, type: :http_action do
  let(:action) { described_class.new(command: command) }

  subject { action.call({}) }

  let(:command) { ->(*) { Success() } }

  context "when command complete business logic correct" do
    let(:command) { ->(*) { Success(:success_result) } }
    let(:success_result) do
      Success([
        {
          "id": 2,
          "title": "new title",
          "description": "new ads",
          "user_id": 45,
          "city": "New york",
          "lat": null,
          "lon": null
        }
      ])
    end

    it "should returns valid result" do
      expect(subject.status).to eq(200)
      expect(subject.body).to be_kind_of(Array)
    end
  end

  context "when command returned error" do
    let(:command) { ->(*) { Failure([:show_error]) } }

    let(:expected_result_body) do
      [{
         "error_message": "Ошибка поиска результатов"
       }.to_json]
    end

    it "should return failure result" do
      result = subject
      expect(result.status).to be(503)
      expect(result.body).to eq(expected_result_body)
    end
  end
end
