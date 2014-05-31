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
            STDERR.puts( "\n" )
          end
          
          nil
        end
        
        # Default, may want to override how the registry behaves.
        # If you don't provide a key argument, then the object needs to 
        # respond to .loader_pattern_registry_key()
        def loader_pattern_register_item( obj, key = nil )
          return nil if obj.nil?
          @loader_pattern_registry ||= {}

          key = obj.loader_pattern_registry_key if key.nil?
          
          if loader_pattern_is_item_registerable?( obj )
            if @loader_pattern_warn_on_key_changes && loader_pattern_registry_lookup( key )
              warn( "class #{self} is replacing lookup key #{key.inspect}" )
            end
              
            return @loader_pattern_registry[ key ] = obj
          else
            warn( "#{obj} is not an instance of a registerable class.  Registerable classes: #{self.loader_pattern_only_register_classes.inspect}" )
            return nil
          end
        end
        
        def loader_pattern_registry_lookup( key )
          @loader_pattern_registry ||= {}
          @loader_pattern_registry[key]
        end
        
        def loader_pattern_registry
          @loader_pattern_registry
        end
        
        def loader_pattern_only_register_classes( *args )
          if args.length > 0
            @loader_pattern_only_register_classes = args
          end
            
          @loader_pattern_only_register_classes || []
        end
        
        def loader_pattern_is_item_registerable?( item )
          return true if loader_pattern_only_register_classes.fwf_blank?
          
          for klass in @loader_pattern_only_register_classes
            return true if item.is_a?( klass )
          end
          
          return false
        end
        
    
        # Assumes that every file in the directory and subdirectories contain ruby code that
        # will yield an object that the loader is looking for.  It also automatically
        # adds the resulting object to a registry.
        # You may want to override this if you're looking for different behavior.
        def loader_pattern_load_from_dir( *dirs )
          for dir in dirs
            dir = dir.fwf_filepath
            @loader_pattern_directories ||= []
            @loader_pattern_directories << dir
      
            for file in dir.glob( "**", self.loader_pattern_extension )
              obj = self.loader_pattern_load_item( file )
              self.loader_pattern_register_item( obj ) if self.loader_pattern_is_item_registerable?( obj )
            end
          end
        end
        
        def loader_pattern_loaded_directories
          @loader_pattern_directories ||= []
        end
        
        def loader_pattern_configure( *args )
          for arg in args
            case arg
            when :bracketwise_lookup
              self.class_eval do
                def self.[]( key )
                  loader_pattern_registry_lookup( key )
                end
                
                def self.[]=( key, val )
                  loader_pattern_register_item( val, key )
                end
              end
            when :warn_on_key_changes
              @loader_pattern_warn_on_key_changes = true
            when :dont_warn_on_key_changes
              @loader_pattern_warn_on_key_changes = false
            when Hash
              for key, val in arg
                case key
                when :key
                  self.class_eval do
                    eval( "alias :loader_pattern_registry_key #{val.inspect}" )
                  end
                when :verbose
                  self.loader_pattern_verbose( val )
                end
              end
            end
          end
        end
      end
    end
  end
end