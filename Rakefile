#!/usr/bin/env rake

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'cucumber/rake/task'
require 'rake/testtask'

namespace :test do
  task :all do
    suites = %w(
      test:features
      test:spec
      test:unit
    )

    suites.each do | suite |
      equals = '=========================================='
    puts equals
    puts "Running: #{ suite }"
      puts equals
    begin
      Rake::Task[ suite ].invoke
    rescue
      puts equals
      puts "FAILED: #{ suite }"
    ensure
      puts equals
      puts "\n"
    end
    end
  end

  Cucumber::Rake::Task.new :features do | t |
    t.cucumber_opts = %w{--format progress --tags ~@ignore}
  end

  desc 'Run the Specs'
  Rake::TestTask.new( :spec ) do | t |
    t.libs << [ 'test' ]
    t.pattern = 'test/spec/**/*_spec.rb'
    t.verbose = true
  end

  desc 'Run the Unit Tests'
  Rake::TestTask.new( :unit ) do | t |
    t.libs << [ 'test' ]
    t.pattern = 'test/unit/**/*_test.rb'
    t.verbose = true
  end
end

task :test    => 'test:all'
task :default => :test
