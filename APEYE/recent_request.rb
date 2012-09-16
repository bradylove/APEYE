class RecentRequest
  attr_accessor :url

  def initialize(data = {})
    @url = data[:url]
  end
end
