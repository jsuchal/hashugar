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

Ruby 1.9.3 benchmark

    OpenStruct create small hash and access once
     43858.0 (±5.5%) i/s -     221820 in   5.074250s (cycle=3697)
    Hashr      create small hash and access once
     67408.9 (±5.0%) i/s -     339780 in   5.053728s (cycle=5663)
    Hashugar   create small hash and access once
    230217.9 (±4.2%) i/s -    1152670 in   5.015705s (cycle=15790)

    OpenStruct create big hash and access once
       974.8 (±4.9%) i/s -       4949 in   5.090937s (cycle=101)
    Hashr     create big hash and access once
      3468.1 (±5.9%) i/s -      17450 in   5.051485s (cycle=349)
    Hashugar   create big hash and access once
     12738.3 (±2.6%) i/s -      64220 in   5.045018s (cycle=1235)

    OpenStruct create small hash and access ten times
     46170.2 (±2.7%) i/s -     231362 in   5.014712s (cycle=3989)
    Hashr      create small hash and access ten times
     41818.8 (±2.5%) i/s -     210320 in   5.032433s (cycle=3824)
    Hashugar   create small hash and access ten times
     82216.8 (±2.3%) i/s -     411742 in   5.010785s (cycle=7099)

    OpenStruct create small hash and access fifty times
     36126.0 (±2.8%) i/s -     182112 in   5.044983s (cycle=3252)
    Hashr      create small hash and access fifty times
     15584.9 (±2.5%) i/s -      78312 in   5.028076s (cycle=1506)
    Hashugar   create small hash and access fifty times
     21513.9 (±6.0%) i/s -     107952 in   5.039238s (cycle=2076)

    OpenStruct create small hash and access hundred times
     28617.9 (±2.7%) i/s -     144928 in   5.068069s (cycle=2588)
    Hashr      create small hash and access hundred times
      8860.7 (±1.7%) i/s -      45103 in   5.091664s (cycle=851)
    Hashugar   create small hash and access hundred times
     11491.3 (±2.4%) i/s -      57512 in   5.007677s (cycle=1106)
