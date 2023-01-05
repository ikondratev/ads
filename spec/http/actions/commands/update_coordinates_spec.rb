require "spec_helper"

describe HTTP::Actions::Commands::UpdateCoordinates, type: :http_action do
  subject { described_class.new(command: command) }

  let(:env_params) do
    {
      "lat" => 1.23,
      "lon" => 4.56,
      "post_id" => 1,
    }
  end

  context "when business logic is correct" do
    let(:command) { ->(*) { Success(:done) } }

    it "should returns valid result" do
      result = subject.call(env_params)
      expect(result.status).to eq(201)
    end
  end

  context "when business logic is incorrect" do
    let(:command) { ->(*) { Failure([:update_coordinates_error]) } }

    let(:expected_result_body) do
      [{
         "error_message": "Координаты не были обновленны"
       }.to_json]
    end

    it "should returns valid result" do
      result = subject.call(env_params)
      expect(result.status).to eq(422)
      expect(result.body).to eq(expected_result_body)
    end
  end
end