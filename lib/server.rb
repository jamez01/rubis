#!/usr/bin/env ruby

## rubis server
require 'drb'
require './lib/store.rb'
require './lib/version.rb'
require './lib/dumper.rb'
# Rubis is a key/value.  The store can be any object in the ruby standard library.
module Rubis
  # The Rubis server leverages druby and listens on port 9594 by default.
  module Server
    class Start
      def initialize(config = {})
        @config = { :port => 9594,
                    :address => '127.0.0.1',
                    :acl => [],
                    :slave => false,
                    :store => :Default }
        @config.merge!(config) if config.class == Hash
        #raise "Unknown store: #{config[:store]}" unless Store.?(@config[:store].to_sym) and Store.const_get(@config[:store]).class == Class
        $store = Store::Default::Default_Store.new
        puts @config.inspect
        DRb.start_service("druby://#{@config[:address]}:#{@config[:port]}",$store)
      end
    end
  end
  def self.run(config = {})
    puts "starting server"
    server=Server::Start.new(config)
    $store.load(Rubis::Dumper::MarshalDump.restore) if File.exist?('./rubis.db')
    Thread.new {
    loop do
      sleep 5
      puts "Dumping Database.."
      Rubis::Dumper::MarshalDump.save($store.dump)
      puts "Dump Complete."
     end }
    DRb.thread.join
  end
end
