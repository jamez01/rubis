require './lib/orm.rb'
require './lib/client.rb'
require 'drb'

# Server must be running for example to work.
database = Rubis::Client.connect("druby://127.0.0.1:9594","test")
puts "Connceting.."
puts "Data existed in database:"
database.keys.each {|x| puts "#{x}: #{database[x].inspect}" }
sleep 1
puts "Populating DB with data"
# Fun with hashes.
pw1=rand(100000)
database.customers = [{:id => 1, :login => "james",:password=>pw1},{:id=>2,:login=>"tom",:password=>pw1},{:id => 3,:login=>"john",:password=>"insecure"}]
puts database.customers.each {|x| puts x.inspect }
puts "Who has ID 1?"
puts database.customers.find(:id => 1).inspect
puts "Display first user with '#{pw1}' as their password:"
puts database.customers.first(:password=>pw1).inspect # Find first user with password pw1
puts "Display -ALL- users with the password '#{pw1}':"
puts database.customers.find(:password=>pw1).inspect # Find -all- users with password pw1


# Fun with arrays
database.numbers=[rand(10),rand(10)+10,rand(10)]
puts database.numbers.inspect

# Strings too
database.string = "Hello, World!"
puts database.string

# Even OpenStruct!
require 'ostruct'
database.struct = OpenStruct.new
database.struct.test = "Hello, Wolrd!!"
puts database.struct.test

# Even other objects!
class Special
  def initialize(string)
    @string = string
  end
  def string
    @string
  end
end

special = Special.new("Woot")
database.special = special
puts database.special.string
