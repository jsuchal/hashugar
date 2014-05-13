require 'bundler'
Bundler.require
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'hashugar/version'

# todo: cleanup this code fix dependencies

RSpec::Core::RakeTask.new('spec')

task :default => :spec

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

task :bump_version do
	text = File.read 'lib/hashugar/version.rb'
	File.write 'lib/hashugar/version.rb', text.sub(/\.(\d+\D*)'/, ".#{Hashugar::VERSION.next}'"), 'w'
	puts "Bumped version to #{$1.next}"
end

desc "Build gem and push to local gem server via 'geminabox'"
task :push do
	# Note: gem server must not already possess a gem of the same name, or else this will fail
	`gem build hashugar.gemspec`
	Rake::Task.invoke[:bump_version] if File.exist? "hashugar-#{Hashugar::VERSION}.gem"
	`gem inabox hashugar-#{Hashugar::VERSION.next}`
end