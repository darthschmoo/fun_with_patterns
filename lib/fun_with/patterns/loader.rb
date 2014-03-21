module FunWith
  module Patterns
    module Loader
      def self.included( base )
        base.extend( ClassMethods )
        base.loader_pattern_extension("rb") if base.loader_pattern_extension.nil?
      end
    
      module ClassMethods
        # By default, looks for .rb files to evaluate
        # ext => :all  (or "*") to load every file from directory.
        # ext => :rb (or "rb") to load all .rb files (this is default)
        # call without arguments to inquire about current extension.
        def loader_pattern_extension( ext = nil )
          case ext
          when nil
            # do nothing
          when "*", :all
            @loader_pattern_extension = "*"
          else
            @loader_pattern_extension = "*.#{ext}"
          end
          
          @loader_pattern_extension
        end
        
        def loader_pattern_verbose( verbosity = nil )
          @loader_pattern_verbose = verbosity unless verbosity.nil?
          @loader_pattern_verbose
        end
    
        # Default behavior: read the file, evaluate it, expect a ruby object
        # of the class that the loader pattern is installed on.  If anything goes
        # wrong (file no exist, syntax error), returns a nil.
        #
        # Override in your class if you need your files translated
        # into objects differently.
        def loader_pattern_load_item( file )
          file = file.fwf_filepath
          if file.file?
            obj = eval( file.read )
            
            STDOUT.puts( "Loaded file #{file}" ) if self.loader_pattern_verbose
            return obj
          else
            STDERR.puts( "(#{self.class}) Load failed, no such file: #{file}" )
            return nil
          end
        rescue Exception => e
          STDERR.puts( "Could not load file #{file}.  Reason: #{e.class.name} #{e.message}" )
          
          if self.loader_pattern_verbose
            STDERR.puts( puts e.backtrace.map{|line| "\t\t#{line}"}.join("\n") )
            STDERR.puts( "" )
          end
          
          nil
        end
        
        # Default, may want to override how the registry behaves.
        def loader_pattern_register_item( obj )
          return nil if obj.nil?
          return (@loader_pattern_registry ||= {})[ obj.loader_pattern_registry_key ] = obj
        end
        
        def loader_pattern_registry_lookup( key )
          @loader_pattern_registry[key]
        end
        
    
        # Assumes that every file in the directory and subdirectories contain ruby code that
        # will yield an object that the loader is looking for.  It also automatically
        # adds the resulting object to a registry.
        # You may want to override this if you're looking for different behavior.
        def loader_pattern_load_from_dir( dir )
          dir = dir.fwf_filepath
          @loader_pattern_directories ||= []
          @loader_pattern_directories << dir
      
          for file in dir.glob( "**", self.loader_pattern_extension )
            obj = self.loader_pattern_load_item( file )
            self.loader_pattern_register_item( obj )
          end
        end
        
        def loader_pattern_loaded_directories
          @loader_pattern_directories ||= []
        end
      end
    end
  end
end