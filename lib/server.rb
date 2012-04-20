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
                    :protocol => "druby",
                    :acl => [],
                    :slave => false,
                    :dump_delay => 5,
                    :dump_method => Rubis::Dumper::MarshalDump.new,
                    :dump_file => './rubis.db',
                    :store => Store::Default::Default_Store.new }
        @config.merge!(config) if config.class == Hash
        #raise "Unknown store: #{config[:store]}" unless Store.?(@config[:store].to_sym) and Store.const_get(@config[:store]).class == Class
        $store = @config[:store]
        puts @config.inspect
        DRb.start_service("#{@config[:protocol]}://#{@config[:address]}:#{@config[:port]}",$store)
      end
      def run
        $store.load(@config[:dump_method].send(:restore,@config[:dump_file])) if File.exists?(@config[:dump_file])
        dump_thread
        DRb.thread.join
      end
      private
      def dump_thread
        Thread.new {
          loop do
            sleep @config[:dump_delay]
            @config[:dump_method].send(:save,@config[:dump_file],$store.dump)
          end
        }
      end
    end
  end

  def self.run(config = {})
    puts "starting server"
    server=Server::Start.new(config)
    server.run
  end
end
