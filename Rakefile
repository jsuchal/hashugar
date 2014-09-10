require 'bundler'
Bundler.require
require 'pathname'
require 'fileutils'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

# todo: cleanup this code, fix dependencies, setup rspec

RSpec::Core::RakeTask.new('spec')

task :default => :spec

task :check_version do
  require_relative 'lib/hashugar/version'
  $libversion = Hashugar::VERSION
  $gemfile = Pathname.glob('*.gem').first
  $gemversion = $gemfile.to_s.match(/-(\d+\.\d+\.\d+)\.gem/)[1]
  # VCS can be used to detect if key files have been changed
  $dirty = true unless `git diff --name-only lib/hashugar/version.rb`.empty?
end

desc 'Manually increment the PATCH version of the library, according to semantic versioning. Destructive.'
task bump_version: :check_version do
  # This library uses semantic versioning (http://semver.org/)
  if $dirty
    puts "The library appears to have been manually updated to version #{$libversion}."
  else
    $libversion.next!
    text = File.read 'lib/hashugar/version.rb'
    File.write 'lib/hashugar/version.rb', text.sub(/\.(\d+\D*)'/, ".#{$libversion}'"), 'w'
    puts "Bumped version to #{$libversion}"
  end
end

desc 'Build the gem, unless source code has been modified without bumping the version.'
task build: :check_version do
  if $gemversion > $libversion
    abort 'ERROR! The library version appears to be behind that of currently built gem.'
  else
    File.rm $gemfile
    `gem build hashugar.gemspec`
  end
end

desc "Build gem and push to local gem server via 'geminabox'"
task push: :check_version do
  Rake::Task[:build].invoke if $libversion > $gemversion
  # Note: gem server must not already possess a gem of the same name, or else this will fail
  `gem inabox hashugar-#{$libversion}.gem` # todo: find out why this won't work
end

desc 'Benchmark'
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

