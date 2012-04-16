require 'drb'
require 'ostruct'

module Rubis
  # onnect to and use the rubis server:
  #
  # Example:
  #
  #   require 'rubys/client'
  #   Rubis::Client.connet("druby://127.0.0.1:9594","test_database")
  class Client
    # Connect rubis server. return openstruct opeject.
    #
    # Usage:
    #
    # Rubis::Client.connect(<uri>,<database_name>)
    #
    # Example:
    #  require 'rubis/client'
    #  Rubis::Client.connet("druby://127.0.0.1:9594","test_database")
    def self.connect(uri,database)
      @store = DRbObject.new(nil,uri)
      return @store.database(database)
    end
  end
end
