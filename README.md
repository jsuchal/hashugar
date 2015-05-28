# Hashugar (Hash Sugar)

Based on the concept of `OpenStruct`, this data structure evolved from [humble beginnings][1] into a powerful and flexible utilitarian tool that I use extensively and hack on continually.

### Features
- Provides dot-notation access to contained data values, similar to JavaScript object syntax
- Nested initialization and conversion of `Hash` and `Array` objects (universal `to_hashugar` method)
- Protects unique `String` and `Symbol` keys of the same name (dot-notation access `Symbol` key first)
- Supports core `Enumerable` methods for easy iteration/mapping
- Class-level `OPTIONS` hash allows for powerful dynamic behavior configuration ([see below](#options))
- Learn methods from classes like `Hash` (experimental!)

## Usage

`$ gem install hashugar`

Basic examples:

```ruby
hashugar = {:a => 1, 'b' => {:c => 2, :d => [3, 4, {:e => 5}]}}.to_hashugar
hashugar.a # => 1
hashugar.b.c # => 2
hashugar.b.d.last.e # => 5
```

Convert a `Hashugar` object back to a regular Ruby `Hash` recursively:

`hashugar.to_h # => {:a => 1, 'b' => {:c => 2, :d => [3, 4, {:e => 5}]}}`

Teach Hashugar methods from other compatible classes (currently only `Hash` supported):

```ruby
hashugar = { one: 1, two: 2 }.to_hashugar
hashugar.clear # => nil
Hashugar.learn_methods Hash
hashugar.clear # => {}
```

#### Options
- `dehyphenate_keys`

    Causes all hyphens within key names to be replaced by underscores for any key/value pairs added to any `Hashugar` object (does not retroactively modify keys).


[1]: https://github.com/jsuchal/hashugar