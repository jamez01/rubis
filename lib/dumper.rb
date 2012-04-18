
module Rubis
  module Dumper
    class MarshalDump
      def self.save(store)
          dump_file = File.open("rubis.db","w")
          dump_file.sync = true
          dump_file.write(Marshal.dump(store))
          dump_file.close
      end
      def self.restore
        puts "Loading.."
        dump_file = File.open("rubis.db","r")
        store = Marshal.load(dump_file.read)
        dump_file.close
        return store
      end
    end
  end
end
