require "hashugar/version"

class Hashugar
  def initialize(hash)
    @table = {}
    hash.each_pair do |key, value|
      @table[convert_key(key)] = value.to_hashugar
    end
  end

  def method_missing(method, *args, &block)
    method = method.to_s
    if method.chomp!('=')
      self[method] = args.first
    else
      @table[method]
    end
  end

  def [](key)
    @table[convert_key(key)]
  end

  def []=(key, value)
    @table[convert_key(key)] = value
  end

  def to_hashugar
    self
  end

  def respond_to?(key)
    @table.has_key?(convert_key(key))
  end

  private
  def convert_key(key)
    key.is_a?(Symbol) ? key.to_s : key
  end
end

class Hash
  def to_hashugar
    Hashugar.new(self)
  end

  private
  def convert_key(key)
    key.is_a?(Symbol) ? key.to_s : key
  end
end

class Array
  def to_hashugar
    # TODO lazy?
    Array.new(collect(&:to_hashugar))
  end
end

class Object
  def to_hashugar
    self
  end
end