require "application_helper"

describe Posting::Commands::ShowAllPosts do
  subject { described_class.new }

  before do
    allow(Sequel::Model).to receive(:all).and_return([])
  end

  describe "#call" do
    context "without any errors" do
      it "should return valid result" do
        result = subject.call
        expect { result }.not_to raise_error
        expect(result.success?).to be_truthy
      end
    end

    context "in case of runtime error" do
      before do
        allow(Sequel::Model).to receive(:all).and_raise(StandardError)
      end

      it "should be failure result" do
        result = subject.call
        expect { result }.not_to raise_error
        expect(result.success?).to be_falsey
      end
    end
  end
end
