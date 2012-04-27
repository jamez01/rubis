require 'redis'
require './lib/store.rb'
require './lib/client.rb'
require 'benchmark'

redis = Redis.new

rubis = Rubis::Client.connect('druby://localhost:9594','benchmark')


Benchmark.bm(5) do |x|
  puts "Writes:"
  x.report("Redis:")   { (1..1000).each { |i|  redis[("key#{i}").to_sym] = "test-#{i}" } }
  x.report("Rubis:") { (1..1000).each { |i| rubis["key#{i}".to_sym] = "test-#{i}" }}
  puts "Reads:"
  x.report("Redis:")   { (1..1000).each { |i|  redis[("key#{i}").to_sym] } }
  x.report("Rubis:") { (1..1000).each { |i| rubis["key#{i}".to_sym] }}
end