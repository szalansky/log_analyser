class FileSource
  def initialize(handle)
    @handle = handle
  end

  attr_reader :handle

  def each_entry
    handle.each_line do |line|
      yield line
    end
  end
end
