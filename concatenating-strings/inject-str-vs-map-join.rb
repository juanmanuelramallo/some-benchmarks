require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'benchmark-ips'
end

Benchmark.ips do |x|
  x.report("map-join") do |count|
    Array.new(count, { text: 'text' }).map { |hash| hash[:text] }.join
  end

  x.report("inject") do |count|
    Array.new(count, { text: 'text' }).inject(String.new) { |memo, hash| memo << hash[:text] }
  end

  x.compare!
end
