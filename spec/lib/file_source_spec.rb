require "spec_helper"
require "file_source"

describe FileSource do
  describe "#each_entry" do
    let(:file) { File.open("spec/fixtures/webserver.log", "r") }
    let(:source) { described_class.new(file) }
    after { file.close }

    it "yields each file line" do
      expect { |b| source.each_entry(&b) }.to yield_successive_args(
        "/help_page/1 126.318.035.038\n",
        " /home 184.123.665.067\n",
        "/home 184.123.665.066 \n",
        "/about/2 444.701.448.104\n"
     )
    end
  end
end
