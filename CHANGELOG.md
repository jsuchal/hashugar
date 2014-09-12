### Hashugar changelog

## 0.0.13 / 2014-09-10
- Added `Hashugar#shift`

## 0.0.12 / 2014-09-09
- Added `Hashugar#update` and specs
- Added `Hashugar::[]`

## 0.0.11 / 2014-04-13
- Minor code improvements/fixes.

## 0.0.10 / 2014-04-19
- Added capability for the `Hashugar` class to enable translation of hyphens in Hash keys to underscores, dynamically.

## 0.0.9 / 2014-04-19
- Modified `Hashugar.new` so as not to require an argument; the new form passes an empty `Hash` as default
- Added the capability to delegate methods calls from specified classes so that Hashugar recognizes them and converts the table to that object so it can call the appropriate implementation, basically polymorphism.

## 0.0.7 / 2013-11-25
- Added `to_new_hash` for deep conversion of a `Hashugar` object to a regular Ruby `Hash`