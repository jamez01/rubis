require 'redis'
require './lib/store.rb'
require 'benchmark'

redis = Redis.new

DRb.start_service
store = DRbObject.new(nil,"druby://127.0.0.1:9594")



Benchmark.bm(5) do |x|
  puts "Writes:"
  x.report("Redis:")   { (1..1000).each { |i|  redis[("key#{i}").to_sym] = "test-#{i}" } }
  x.report("Rubis:") { (1..1000).each { |i| store[("key#{i}").to_sym].y = "test-#{i}" }}
  puts "Reads:"
  x.report("Redis:")   { (1..1000).each { |i|  redis[("key#{i}").to_sym] = "test-#{i}" } }
  x.report("Rubis:") { (1..1000).each { |i| store[("key#{i}").to_sym].y = "test-#{i}" }}
  
end

