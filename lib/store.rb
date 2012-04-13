require 'drb'
require 'ostruct'

class OpenStruct
  include DRbUndumped
  #eundef id
end
module Rubis
  module Store
    module Default
      def self.init

        return Default_Store.new
      end
      class Default_Store
        #include DRbUndumped
        def initialize
          #return self
          @databases = Hash.new
        end
        def _databases
          @databases.keys
        end
        def method_missing(method,*args)
          @databases[method.to_s.gsub(/=$/,"").to_sym] = OpenStruct.new
          (class << self;self; end).class_eval do
            define_method(method.to_s.gsub(/=$/,"").to_sym) do
              @databases[method]
            end
          end
          return self.send(method.to_s.gsub(/=$/,"").to_sym,*args) #if args
        end
      end
    end
  end
end
