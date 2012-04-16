require './lib/orm.rb'
require 'drb'

# Server must be running for example to work.

DRb.start_service
store = DRbObject.new(nil,"druby://127.0.0.1:9594")

store.myapp.customers = [{:id => 1, :login => "james",:password=>"SomeHash"},{:id=>2,:login=>"tom",:password=>"SomeHash"}]
store.myapp.xxx = ""

puts store.myapp.customers[0].inspect
puts store.myapp.customers.find(:id => 1).inspect # Who has ID 1?
puts store.myapp.customers.first(:password=>"SomeHash").inspect # Find first user with password "SomeHash"
puts store.myapp.customers.find(:password=>"SomeHash").inspect # Find -all- users with password "SomeHash"


