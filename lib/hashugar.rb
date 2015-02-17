require_relative 'hashugar/version'

# This class operates by essentially pretending to be a Hash with data
# accessible via dot-notation syntax. This works by thinly wrapping a real
# Hash with metaprogramming magic, resulting in the following features:
#
# - Hashugar objects containing 'duplicate' keys, that is, two unique
#   keys of the same name but different type (String and Symbol), return
#   the key which is a Symbol upon being called with dot-notation syntax.
#   They still provide access to the String key, you must simply use the
#   standard bracket syntax to access that value.
#
# - The 'learn_methods' method allows Hashugar to 'learn' to behave as foreign
#   classes do when treated as a Hash, such as when they implement methods
#   that Hash does, or inherit from Hash. An example is Rails, which uses
#   the class HashWithIndifferentAccess to provide what the class name
#   suggests, by inheriting from Hash and adding functionality. If such
#   objects are converted to Hashugar, they lose the ability to access
#   methods formerly defined by the object which aren't implemented in
#   Hashugar, such as Hash#stringify_keys in Rails. To 'learn' methods
#   used in other classes, Hashugar implements delegation by using the
#   method_missing technique. At invocation, Hashugar identifies which
#   class a 'learned' method belongs to, and attempts to convert itself to
#   an instance of that class, and calls the method on it, passing all
#   arguments and optional block transparently from method_missing.
#
#   Note that this approach does not support the delegation of multiple
#   methods of the same name; the last class 'learned' from will be used.
#
#   WARNING! This has only been tested with Hash.
#   todo: test this functionality more
#
class Hashugar
	@@learned_methods = {}

	# The option wrapper instantiates Hashugar 'global' options that affect either
	# the Hashugar class itself, or all instances therof; allowing unique logic and
	# special behavior to be implemented while concurrently providing the values
	# as a simple Hash accessible via the Hashugar::OPTIONS.
	#
	# @param [List<Symbol>] List of options (preferably an Array)
	#
	OPTION_WRAPPER = Struct.new :dehyphenate_keys do

		# Overriding Struct#inspect allows Hashugar::OPTIONS to return a Hash
		def inspect
			self.to_h
		end

		# This option functions as a boolean switch that enables or disables the
		# automatic conversion of all hyphens in Hashugar object keys into underscores.
		# Since hyphens are extremely popular as a means of data delineation, there
		# often arise inconvenient situations in which data must be massaged at some
		# point, or worse, expensive dependency injection or analogous measure
		# taken, in order to ensure compatibility. This implementation is designed to
		# create the least amount of side effects and/or weight, by directly altering
		# the function of the class dynamically.
		#
		# todo: write tests
		# todo: consider extracting the operation to a decoupled method or module
		# todo: add capability to perform reverse translation (underscores to hyphens)
		#
		def dehyphenate_keys=(bool)
			self[:dehyphenate_keys] = bool
			if bool == true
				Hashugar.class_eval(%q[
					def stringify_key(key)
						(key.is_a?(Symbol) ? key.to_s : key).gsub(/-/, '_')
					end
				])
			elsif bool == false
				Hashugar.class_eval(%q[
					def stringify_key(key)
						key.is_a?(Symbol) ? key.to_s : key
					end
				])
      else
				raise ArgumentError
			end
		end
	end

	# Values passed to this constructor will set option defaults
	OPTIONS = OPTION_WRAPPER.new false

	def initialize(hash={}, options={})
		@table = {}
		@table_with_original_keys = {}
		hash.each_pair do |key, value|
			hashugar = value.to_hashugar
			@table_with_original_keys[key] = hashugar
			@table[stringify_key(key)] = hashugar
		end
	end

  class << self
    def [](*hash)
      Hashugar.new Hash[*hash]
    end
  end

  def to_hashugar
		self
	end

	# This code is a bit magical (thanks to Jan Suchal, the original author!).
	# I added the capability to 'learn' behavior of other classes, by recognizing
	# their methods and delegating calls to them, when Hashugar doesn't implement
	#
	# todo: add functionality for other classes (only Hash is supported for now)
	#
	def method_missing(method, *args, &block)
		if @@learned_methods.has_key?(method.to_sym)
			self.to_h.send(method, *args)
		else
			method = method.to_s
			if method.chomp!('=')
				self[method] = args.first
			else
				@table[method]
			end
		end
	end

	def respond_to?(key)
		@table.has_key?(stringify_key(key))
	end

	# Assigns all public instance methods implemented by the given class
	# or list of classes to a Hash, for use in Hashugar#method_missing.
	# Each method points to the class that calls to it will be delegated to.
	#
	# @param klasses [Class, Array<Class>] Class or list of Classes
	#
	# todo: test this more, especially with :=
	def self.learn_methods_of(klasses)
		[klasses].flatten.each do |klass|
			if klass.is_a? Class
				klass.public_instance_methods(false).each { |m| @@learned_methods[m] = klass }
			else
				raise TypeError, 'Must a Class object.'
			end
		end
	end

  #
  # Access and modification
  #

  def update(other)
    self.to_h.update(other.to_h).to_hashugar
  end

  # Removes a key-value pair and returns it as the two-item array
  #
  # @return [Array] First available key-value pair in the Hashugar object's internal hash
  #
  def shift
    kvpair = self.to_h.shift
    @table.delete kvpair.first
    kvpair
  end

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

	# Technically a Hash method, but a good one
	def values_at(*keys)
		@table_with_original_keys.values_at *keys
	end

	#
	#  Formatting
	#

	def to_s
		self.to_h.to_s
	end

	# private

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
