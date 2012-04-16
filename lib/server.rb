#!/usr/bin/env ruby

## rubis server
require 'drb'
require './lib/store.rb'

module Rubis
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
        @store = Store::Default::Default_Store.new
        puts @config.inspect
        DRb.start_service("druby://#{@config[:address]}:#{@config[:port]}",@store)
        DRb.thread.join
      end
    end
  end
  def self.run(config = {})
    puts "starting server"
    server=Server::Start.new(config)
  end
end
