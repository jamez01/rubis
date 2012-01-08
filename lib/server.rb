#!/usr/bin/env ruby

## rubis server
require 'drb'

module Rubis
  module Server
    class Start
      def initialize(config)
        @config = { :port => 9594,
                    :address => '127.0.0.1',

      end
    end
  end
  def self.run!
    return Server::Start.new
  end
end
