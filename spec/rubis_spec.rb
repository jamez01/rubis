require './lib/server.rb'
require './lib/client.rb'

Thread.new { Rubis.run(:dump_method => Rubis::Dumper::None.new, :port => 9595) }
sleep 2

$rubis = Rubis::Client.connect("127.0.0.1:9595","rspec")

describe Rubis do
  describe "Store Something" do
    it "Accepts a key and a value" do
      $rubis.something = "Hello, World!"
    end
    it "Returns 'Hello, World!' from the something key" do
      $rubis.someting == "Hello, World!"
    end
  end
end
