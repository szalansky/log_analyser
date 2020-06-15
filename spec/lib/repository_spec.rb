require "spec_helper"
require "repository"

describe Repository do
  let(:repo) { described_class.new }

  describe "#append" do
    before(:each) do
      repo.append("/home", "8.8.8.8")
      repo.append("/home", "2.2.2.2")
      repo.append("/home", "8.8.8.8")
    end

    it "stores the visits" do
      expect(repo.visits).to eq({
        "/home" => { url: "/home", total_visits: 3, unique_visits: 2 }
      })
    end
  end

  describe "#each_by_total_visits" do
    before(:each) do
      repo.append("/home", "8.8.8.8")
      repo.append("/home", "2.2.2.2")
      repo.append("/home", "8.8.8.8")
      repo.append("/home", "8.8.8.8")
      repo.append("/about", "2.2.2.2")
    end

    it "returns correct result" do
      expect(repo.each_by_total_visits).to eq([
        { url: "/home", total_visits: 4, unique_visits: 2 },
        { url: "/about", total_visits: 1, unique_visits: 1 },
      ])
    end
  end

  describe "#each_by_unique_visits" do
    before(:each) do
      repo.append("/home", "8.8.8.8")
      repo.append("/home", "2.2.2.2")
      repo.append("/home", "8.8.8.8")
      repo.append("/home", "8.8.8.8")
      repo.append("/about", "2.2.2.2")
      end

    it "returns correct result" do
      expect(repo.each_by_unique_visits).to eq([
        { url: "/home", total_visits: 4, unique_visits: 2 },
        { url: "/about", total_visits: 1, unique_visits: 1 },
      ])
    end
  end
end
