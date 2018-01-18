require "hashugar/version"

class Hashugar
  def initialize(hash)
    @table = {}
    hash.each_pair do |key, value|
      @table[key] = value.to_hashugar
    end
  end

  def method_missing(method, *args, &block)
    method = method.to_s
    if method.chomp!('=')
      self[method] = args.first
    else
      if @table.respond_to?(method)
        @table.send(method, *args, &block)
      else
        self[method]
      end
    end
  end

  def [](key)
    @table[key.to_s] || @table[key.to_sym]
  end

  def []=(key, value)
    if @table.has_key?(key.to_s)
      @table[key.to_s] = value
    else
      @table[key.to_sym] = value
    end
  end

  def respond_to?(key, include_all=false)
    super || @table.respond_to?(key) || @table.has_key?(key.to_s) || @table.has_key?(key.to_sym)
  end

  def to_hash
    hash = @table.to_hash
    hash.each do |key, value|
      hash[key] = value.to_hash if value.is_a?(Hashugar)
    end
  end

  def inspect
    "#<#{self.class} #{to_hash.inspect}>"
  end
end

class Hash
  def to_hashugar
    Hashugar.new(self)
  end
end

class Array
  def to_hashugar
    map(&:to_hashugar)
  end
end

class Object
  def to_hashugar
    self
  end
end
