#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new('spec')

# If you want to make this the default task
task :default => :spec

desc "Benchmark"
task :bench do
  require 'benchmark/ips'
  require 'ostruct'
  require 'hashr'
  require 'hashugar'

  SMALL_HASH = {:a => 1, :b => 2}
  BIG_HASH = {}; 100.times {|i| BIG_HASH[i.to_s] = "item#{i}" }

  Benchmark.ips do |x|
    x.report 'OpenStruct create small hash and access once', 'OpenStruct.new(SMALL_HASH).item5'
    x.report 'Hashr      create small hash and access once', 'Hashr.new(SMALL_HASH).item5'
    x.report 'Hashugar   create small hash and access once', 'Hashugar.new(SMALL_HASH).item5'

    x.report 'OpenStruct create big hash and access once', 'OpenStruct.new(BIG_HASH).item5'
    x.report 'Hashr     create big hash and access once', 'Hashr.new(BIG_HASH).item5'
    x.report 'Hashugar   create big hash and access once', 'Hashugar.new(BIG_HASH).item5'

    x.report 'OpenStruct create small hash and access ten times', 'h = OpenStruct.new(SMALL_HASH); i = 0; while i < 10; h.a; i += 1; end'
    x.report 'Hashr      create small hash and access ten times', 'h = Hashr.new(SMALL_HASH); i = 0; while i < 10; h.a; i += 1; end'
    x.report 'Hashugar   create small hash and access ten times', 'h = Hashugar.new(SMALL_HASH); i = 0; while i < 10; h.a; i += 1; end'

    x.report 'OpenStruct create small hash and access fifty times', 'h = OpenStruct.new(SMALL_HASH); i = 0; while i < 50; h.a; i += 1; end'
    x.report 'Hashr      create small hash and access fifty times', 'h = Hashr.new(SMALL_HASH); i = 0; while i < 50; h.a; i += 1; end'
    x.report 'Hashugar   create small hash and access fifty times', 'h = Hashugar.new(SMALL_HASH); i = 0; while i < 50; h.a; i += 1; end'

    x.report 'OpenStruct create small hash and access hundred times', 'h = OpenStruct.new(SMALL_HASH); i = 0; while i < 100; h.a; i += 1; end'
    x.report 'Hashr      create small hash and access hundred times', 'h = Hashr.new(SMALL_HASH); i = 0; while i < 100; h.a; i += 1; end'
    x.report 'Hashugar   create small hash and access hundred times', 'h = Hashugar.new(SMALL_HASH); i = 0; while i < 100; h.a; i += 1; end'
  end
end
