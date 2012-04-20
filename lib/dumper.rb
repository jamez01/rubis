
module Rubis
  module Dumper
    class None
     def save(file,store)
      return true
     end
     def restore(file)
       return false
     end
    end
    class MarshalDump
      def save(file,store)
          dump_file = File.open(file,"w")
          dump_file.sync = true
          dump_file.write(Marshal.dump(store))
          dump_file.close
          return true
      end
      def restore(file)
        puts "Loading.."
        dump_file = File.open(file,"r")
        store = Marshal.load(dump_file.read)
        dump_file.close
        return store
      end
    end
  end
end
