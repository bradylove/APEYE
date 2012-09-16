class Parameter
  attr_accessor :sign, :key, :value

  def initialize(data = {})
    @sign  = data[:sign]  || false
    @key   = data[:key]   || ""
    @value = data[:value] || ""

    puts "New parameter created"
  end

  def to_puts
    puts "sign: #{@sign}, key: #{@key}, value: #{@value}"
  end

  def to_a
    ["sign" => @sign, "key" => @key, "value" => @value]
  end
end
