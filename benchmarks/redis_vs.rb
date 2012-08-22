require 'redis'
require './lib/store.rb'
require './lib/client.rb'
require 'benchmark'

redis = Redis.new

rubis = Rubis::Client.connect('druby://localhost:9594','benchmark')

Benchmark.bm(2) do |x|
  puts "Writes:"
  x.report("Redis:")   { (1..4000).each { |i|  redis[("key#{i}").to_sym] = "Test #{i}"  } }
  x.report("Rubis:") { (1..4000).each { |i| rubis["key#{i}".to_sym] = "Test #{i}" }}
  puts "Reads:"
  x.report("Redis:")   { (1..4000).each { |i|  redis[("key#{i}").to_sym] } }
  x.report("Rubis:") { (1..4000).each { |i| rubis["key#{i}".to_sym] }}
end