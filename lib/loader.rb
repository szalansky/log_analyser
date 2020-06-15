class Loader
  def initialize(source)
    @source = source
  end

  attr_reader :source

  def each_entry
    source.each_entry do |entry|
      sanitised = entry
      url, ip = sanitised.split(" ")
      yield url, ip
    end
  end
end
