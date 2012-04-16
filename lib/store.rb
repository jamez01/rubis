require 'drb'
require 'ostruct'

class OpenStruct
  include DRbUndumped
  undef id if OpenStruct.respond_to?(:id) # 1.8.x compatibility
  # Added a method to list the available keys in a database.
  def keys
    @table.keys
  end
end
module Rubis
  # Data Stores contain the database.  All databases must use the same store.
  module Store
    # The Default store uses a slightly modified openstruct.
    module Default
      def self.init
        return Default_Store.new
      end
      # The Default store
      class Default_Store
        #include DRbUndumped
        def initialize()
          #return self
          @@databases ||= Hash.new
        end
        # Call a specific database.
        def database(database_name)
          @@databases[database_name] ||= OpenStruct.new
          return @@databases[database_name]
        end
        # List All Databases.
        def databases # :yields: array
          return @@databases.keys
        end
      end
    end
  end
end
