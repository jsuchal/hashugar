require "hashugar/version"

class Hashugar
	def initialize(hash)
		@table = {}
		@table_with_original_keys = {}
		hash.each_pair do |key, value|
			hashugar = value.to_hashugar
			@table_with_original_keys[key] = hashugar
			@table[convert_key(key)] = hashugar
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

	# This method obviously converts a Hashugar struct back to a Hash.
	# @return [Hash] Standard Ruby Hash from deep conversion of Hashugar struct.
	def to_new_hash
		@table_with_original_keys.reduce({}) do |hash, (key, value)|
			hash[key] = value.to_new_hash
			hash
		end
	end

	def respond_to?(key)
		@table.has_key?(convert_key(key))
	end

	def each(&block)
		@table_with_original_keys.each(&block)
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

	def to_new_hash
		self.to_hash
	end
end

class Array
	def to_hashugar
		# TODO lazy?
		Array.new(collect(&:to_hashugar))
	end

	def to_new_hash
		Array.new(collect(&:to_new_hash))
	end
end

class Object
	def to_hashugar
		self
	end

	def to_new_hash
		self
	end
end
