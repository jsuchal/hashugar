require "hashugar/version"

class Hashugar
  def initialize(hash)
    @table = {}
    @table_with_original_keys = {}
    hash.each_pair do |key, value|
      hashugar = value.to_hashugar
      @table_with_original_keys[key] = hashugar
      @table[stringify(key)] = hashugar
    end
  end

  def method_missing(method, *args, &block)
    method = method.to_s
    if method.chomp!('=')
      @table[method] = args.first
    else
      @table[method]
    end
  end

  def [](key)
    @table[stringify(key)]
  end

  def []=(key, value)
    @table[stringify(key)] = value
  end

  def respond_to?(key, include_all=false)
    super(key) || @table.has_key?(stringify(key))
  end

  def each(&block)
    @table_with_original_keys.each(&block)
  end

  def to_hash
    hash = {}
    @table.each_pair do |key, value|
      hash[symbolize(key)] = value.is_a?(Hashugar) ? value.to_hash : value
    end
    hash
  end

  def empty?
    @table.empty?
  end

  private
  def stringify(key)
    key.is_a?(Symbol) ? key.to_s : key
  end

  def symbolize(key)
    key.to_s.to_sym
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
