require './lib/orm.rb'
require './lib/client.rb'
require 'drb'

# Server must be running for example to work.
database = Rubis::Client.connect("druby://127.0.0.1:9594","test")
puts "Connceting.."
puts database.keys.inspect
puts "Data existed in database:"
puts database.customers.join("\n") if database.keys.include?(:customers)
puts "Populating DB with data"
pw1=rand(100000)
database.customers = [{:id => 1, :login => "james",:password=>pw1},{:id=>2,:login=>"tom",:password=>pw1}]
puts database.customers.join("\n")

puts database.customers.find(:id => 1).inspect # Who has ID 1?
puts database.customers.first(:password=>pw1).inspect # Find first user with password "SomeHash"
puts database.customers.find(:password=>pw1).inspect # Find -all- users with password "SomeHash"
