require File.expand_path '../hashugar/version', __FILE__

class Hashugar
	def initialize(hash)
		@table = {}
		@table_with_original_keys = {}
		hash.each_pair do |key, value|
			hashugar = value.to_hashugar
			@table_with_original_keys[key] = hashugar
			@table[stringify_key(key)] = hashugar
		end
	end

	def to_hashugar
		self
	end

	def method_missing(method, *args, &block)
		method = method.to_s
		if method.chomp!('=')
			self[method] = args.first
		else
			@table[method]
		end
	end

	def respond_to?(key)
		@table.has_key?(stringify_key(key))
	end

	#
	#  Hash-like methods
	#

	def [](key)
		@table[stringify_key(key)]
	end

	def []=(key, value)
		@table[stringify_key(key)] = value
	end

	# This method (obviously) converts a Hashugar struct back to a Hash.
	# NOTE: ENV already implements 'to_hash', necessitating an alternate method name.
	#
	# @return [Hash] Standard Ruby Hash from deep conversion of Hashugar struct.
	#
	def to_h
		@table.reduce({}) do |hash, (key, value)|
			hash[key] = value.to_h
			hash
		end
	end

	#
	#  Enumerable methods
	#

	def each(&block)
		@table_with_original_keys.each(&block)
	end

	def collect(&block)
		@table_with_original_keys.collect(&block)
	end

	#
	#  Formatting
	#

	def to_s
		self.to_h.to_s
	end

	private

	def stringify_key(key)
		key.is_a?(Symbol) ? key.to_s : key
	end
end

class Hash
	def to_hashugar
		Hashugar.new(self)
	end

	def to_h
		self.to_hash
	end
end

class Array
	def to_hashugar
		# TODO lazy?
		Array.new(collect(&:to_hashugar))
	end

	def to_h
		Array.new(collect(&:to_h))
	end
end

class String
	def to_h
		self
	end
end

class Object
	def to_hashugar
		self
	end

	def to_h
		self
	end
end
