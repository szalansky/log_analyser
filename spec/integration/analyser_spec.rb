require "spec_helper"

require "open3"

describe "analyser.rb" do
  context "no arguments passed" do
    let(:command) { "./analyser.rb" }

    it "returns error" do
      stdout, stderr, status = Open3.capture3(command)
      expect(status.exitstatus).to eq(1)
      expect(stdout).to eq("")
      expect(stderr).to eq("Please provide file to analyse.\n")
    end
  end

  context "--file=FILE argument passed" do
    let(:command) { "./analyser.rb --file=#{file_path}" }

    context "blank file path" do
      let(:file_path) { "" }

      it "returns error" do
        stdout, stderr, status = Open3.capture3(command)
        expect(status.exitstatus).to eq(1)
        expect(stdout).to eq("")
        expect(stderr).to eq("Blank FILE argument in -fFILE/--file=FILE.\n")
      end
    end

    context "file does not exist" do
      let(:file_path) { "./spec/non_existent_file.log" }

      it "returns error" do
        stdout, stderr, status = Open3.capture3(command)
        expect(status.exitstatus).to eq(1)
        expect(stdout).to eq("")
        expect(stderr).to eq("Could not read #{file_path} file.\n")
      end
    end

    context "file exists" do
      let(:file_path) { "./example/webserver.log" }

      it "returns summary of log file" do
        stdout, stderr, status = Open3.capture3(command)
        expect(status.exitstatus).to eq(0)
        stdout = <<~STDOUT
	Page views:
	/about/2 90 visits
	/contact 89 visits
	/index 82 visits
	/about 81 visits
	/help_page/1 80 visits
	/home 78 visits

	Unique page views
	/index 23 unique visits
	/home 23 unique visits
	/contact 23 unique visits
	/help_page/1 23 unique visits
	/about/2 22 unique visits
	/about 21 unique visits
        STDOUT

        expect(stdout).to eq(stdout)
      end
    end
  end
end
