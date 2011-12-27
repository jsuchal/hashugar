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
     47458.0 (±3.4%) i/s -     238380 in   5.029038s (cycle=4110)
    Hashr      create small hash and access once
     70290.2 (±3.1%) i/s -     356240 in   5.072827s (cycle=5840)
    Hashugar   create small hash and access once
    873106.5 (±4.8%) i/s -    4381784 in   5.030829s (cycle=37774)

    OpenStruct create big hash and access once
      1028.3 (±3.0%) i/s -       5202 in   5.063657s (cycle=102)
    Hashr     create big hash and access once
      3686.6 (±2.7%) i/s -      18615 in   5.053303s (cycle=365)
    Hashugar   create big hash and access once
    839766.3 (±4.9%) i/s -    4199760 in   5.013690s (cycle=36840)

    OpenStruct create small hash and access ten times
     46554.1 (±2.8%) i/s -     234958 in   5.050963s (cycle=4051)
    Hashr      create small hash and access ten times
     42768.0 (±2.4%) i/s -     216543 in   5.066085s (cycle=3799)
    Hashugar   create small hash and access ten times
    121441.3 (±4.1%) i/s -     608597 in   5.021793s (cycle=9977)

    OpenStruct create small hash and access fifty times
     36047.5 (±2.8%) i/s -     181390 in   5.035970s (cycle=3298)
    Hashr      create small hash and access fifty times
     15349.6 (±4.1%) i/s -      76752 in   5.008858s (cycle=1476)
    Hashugar   create small hash and access fifty times
     23561.9 (±7.4%) i/s -     117250 in   5.005844s (cycle=2345)

    OpenStruct create small hash and access hundred times
     27801.2 (±5.8%) i/s -     139194 in   5.027806s (cycle=2442)
    Hashr      create small hash and access hundred times
      8223.7 (±6.0%) i/s -      41463 in   5.061138s (cycle=813)
    Hashugar   create small hash and access hundred times
     12406.0 (±3.8%) i/s -      61984 in   5.004111s (cycle=1192)
