require "spec_helper"
require "loader"
require "file_source"

describe Loader do
  describe "#each_entry" do
    let(:file) { File.open("spec/fixtures/webserver.log", "r") }
    let(:source) { FileSource.new(file) }
    let(:loader) { described_class.new(source) }
    after { file.close }

    it "yields each file line" do
      expect { |b| loader.each_entry(&b) }.to yield_successive_args(
        %W(/help_page/1 126.318.035.038),
        %W(/home 184.123.665.067),
        %W(/home 184.123.665.066),
        %W(/about/2 444.701.448.104)
     )
    end
  end
end
