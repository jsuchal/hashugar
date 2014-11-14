Hashugar (Hash Sugar)
=====================

[![Build Status](https://secure.travis-ci.org/jsuchal/hashugar.png)](http://travis-ci.org/jsuchal/hashugar)

Nested OpenStruct alternative optimized for speed especially for many short-lived objects (e.g. results from db).


Usage
-----

`$ gem install hashugar`

-----
```ruby
hashugar = {:a => 1, 'b' => {:c => 2, :d => [3, 4, {:e => 5}]}}.to_hashugar
hashugar.a # => 1
hashugar.b.c # => 2
hashugar.b.d.last.e # => 5
```

How fast is it?
---------------

Let's compare to the competitors - [OpenStruct](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/ostruct/rdoc/OpenStruct.html), [Hashr](https://github.com/svenfuchs/hashr)

`$ rake bench`

Ruby 2.1.3 benchmark

```
OpenStruct create small hash and access once
                       110766.3 (±4.7%) i/s -     557010 in   5.039303s
Hashr      create small hash and access once
                       147007.1 (±2.6%) i/s -     742596 in   5.054958s
Hashugar   create small hash and access once
                       427133.4 (±2.7%) i/s -    2157935 in   5.055919s
OpenStruct create big hash and access once
                         2018.7 (±7.8%) i/s -      10050 in   5.005609s
Hashr      create big hash and access once
                         5021.0 (±4.5%) i/s -      25143 in   5.016474s
Hashugar   create big hash and access once
                        14542.7 (±31.7%) i/s -      65232 in   5.113105s
OpenStruct create small hash and access ten times
                       100424.9 (±5.0%) i/s -     509004 in   5.080745s
Hashr      create small hash and access ten times
                        86539.9 (±3.7%) i/s -     433116 in   5.011856s
Hashugar   create small hash and access ten times
                       166080.6 (±2.6%) i/s -     844704 in   5.089568s
OpenStruct create small hash and access fifty times
                        70585.2 (±5.0%) i/s -     356460 in   5.062517s
Hashr      create small hash and access fifty times
                        32565.7 (±2.4%) i/s -     164788 in   5.063123s
Hashugar   create small hash and access fifty times
                        46460.1 (±4.0%) i/s -     233677 in   5.038378s
OpenStruct create small hash and access hundred times
                        51480.7 (±4.1%) i/s -     261131 in   5.081082s
Hashr      create small hash and access hundred times
                        18201.2 (±2.3%) i/s -      91443 in   5.026730s
Hashugar   create small hash and access hundred times
                        24413.4 (±2.0%) i/s -     124185 in   5.088771s
```

Why is it so fast?
------------------

[OpenStruct defines a method using metaprogramming](https://github.com/ruby/ruby/blob/trunk/lib/ostruct.rb#L166-L173) on first access, but this is a slow operation. [Hashr is converting whole hash on initialization](https://github.com/svenfuchs/hashr/blob/master/lib/hashr.rb#L102-L114) which is slower when you don't need to access all keys and nested keys. Hashugar uses `method_missing`, which is slower in the long run, but faster for short-lived objects, it's also lazy so there is no precomputation/conversion step.
