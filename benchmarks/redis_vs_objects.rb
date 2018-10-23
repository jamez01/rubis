require 'redis'
require './lib/store.rb'
require './lib/client.rb'
require 'benchmark'
require 'securerandom'

redis = Redis.new

rubis = Rubis::Client.connect('druby://localhost:9594','benchmark')

class MyDB
  attr_reader :id
  def initialize(args={})
    @id = SecureRandom.uuid
    attributes
    set_attributes(args)
  end

  private
  def attributes; end

  def set_attributes(args)
    args.each do |arg,value|
      raise "Unkown attribute: #{arg}" unless instance_variable_defined?("@#{arg}") || self.respond_to?(arg)
      self.send("#{arg}=", value)
    end
  end

  def attribute(k,value=nil)
    self.class.send(:attr_accessor, k)
    self.instance_variable_set("@"+k.to_s, value)
  end
end

class User < MyDB
  def attributes
    attribute :name
    attribute :email
    attribute :encrypted_password
    attribute :salt, "4s"
  end
  def password=(pass)
    @encrypted_password = pass.crypt(@salt)
  end
  def password
    @encrypted_password
  end
end

rstring = proc {|x| (5+rand(5)).times.collect { ('a'..'z').to_a.sample }.join}
@users = []
10000.times {|x|
  @users << User.new(name: rstring.call, password: rstring.call, email: "#{rstring.call}@#{rstring.call}.#{['com','net','org'].sample}")
}
require 'yaml'
Benchmark.bm(10) do |x|
  puts "Set"
  x.report("Redis:") { (1..40).each { redis.set('users', @users.to_yaml) } }
  x.report("Rubis:") { (1..40).each {  rubis.users = @users } }
  puts "Count"
  x.report("Redis:") { (1..40).each {  YAML.load(redis.get('users')).count } }
  x.report("Rubis:") { (1..40).each {  rubis.users.count } }
  puts "Find"
  x.report("Redis:") { (1..40).each {  YAML.load(redis.get('users')).find {|x| x.name.length > 4 }} }
  x.report("Rubis:") { (1..40).each {  rubis.users.find {|x| x.name.length > 4 }} }
  puts "Writes:"
  x.report("Redis:")   { (1..4000).each { |i|  redis.set(("key#{i}").to_sym,"Test #{i}")  } }
  x.report("Rubis:") { (1..4000).each { |i| rubis["key#{i}".to_sym] = "Test #{i}" }}
  puts "Reads:"
  x.report("Redis:")   { (1..4000).each { |i|  redis.get(("key#{i}").to_sym) } }
  x.report("Rubis:") { (1..4000).each { |i| rubis["key#{i}".to_sym] }}
end
