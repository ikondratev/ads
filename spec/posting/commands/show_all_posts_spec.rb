require "spec_helper"

RSpec.describe Posting::Commands::ShowAllPosts, type: :command do
  subject { command.call }

  let(:command) { described_class.new(ads_repo: ads_repo) }
  let(:ads_repo) { instance_double(Posting::Repositories::AdsRepo, all: [post]) }
  let(:post) { Posting::Entities::Ads.new(id: 1, user_id: 2, city: "Test city", description: "new test desc", title: "test title", lat: nil, lon: nil) }

  context "when everything is okay" do
    it "shouldn't raise any errors" do
      expect{ subject }.not_to raise_error
      expect(subject).to be_success
    end
  end

  context "when error was raised" do
    before do
      allow_any_instance_of(Posting::Repositories::AdsRepo).to receive(:all).and_raise(StandardError)
    end

    let(:ads_repo) { Posting::Repositories::AdsRepo.new }

    it do
      expect(subject).to be_failure
      expect(subject.failure).to eq([:show_error, { error_message: "show action was failed" }])
    end
  end
end