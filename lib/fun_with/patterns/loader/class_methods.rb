module FunWith
  module Patterns
    module Loader
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
            @loader_pattern_extension = ext
          end
        
          @loader_pattern_extension
        end
        
        def loader_pattern_verbose( verbosity = nil )
          @loader_pattern_verbose = verbosity unless verbosity.nil?
          @loader_pattern_verbose
        end
        
        def loader_pattern_rescue_failing_item_load( file, &block )
          file = file.fwf_filepath.expand
          if file.file?
            obj = yield
            STDOUT.puts( "Loaded file #{file}" ) if self.loader_pattern_verbose
            
            obj
          else
            STDERR.puts( "(#{self.class}) Load failed, no such file: #{file}" )
          end
        rescue Exception => e
          STDERR.puts( "Could not load file #{file}.  Reason: #{e.class.name} #{e.message}" )
        
          if self.loader_pattern_verbose
            STDERR.puts( puts e.backtrace.map{|line| "\t\t#{line}"}.join("\n") )
            STDERR.puts( "\n" )
          end
        
          nil
        end
        
        # Default method, user of the class may want to override how the registry behaves.
        # If you don't provide a key argument, then the object needs to 
        # respond to .loader_pattern_registry_key()
        def loader_pattern_register_item( obj, key = nil )
          return nil if obj.nil?
          @loader_pattern_registry ||= {}
        
          if key.nil?
            if obj.respond_to?( :loader_pattern_registry_key )
              key = obj.loader_pattern_registry_key
            else
              # inferring a default key from the filepath is handled by the load_from_dir() method
              raise "#{self.class} not registered.  No registry key given, and object does not respond to .loader_pattern_registry_key()."
            end
          end
        
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
            
            for file in dir.glob( :ext => self.loader_pattern_extension, :recurse => true )
              obj = self.loader_pattern_load_item( file )
              
              # checks to see if you're only allowed to register objects of certain types
              if self.loader_pattern_is_item_registerable?( obj )
                if obj.respond_to?( :loader_pattern_registry_key )
                  self.loader_pattern_register_item( obj )
                else
                  # Generate a default key from the filename
                  chunks = (file.relative_path_from( dir ).dirname.split << file.basename_no_ext).map(&:to_s).reject{|s| s == "." }
                  key = chunks.join(":")
                  self.loader_pattern_register_item( obj, key )
                end
              end
            end
          end
        end
        
        def loader_pattern_loaded_directories
          @loader_pattern_directories ||= []
        end
        
        # Handle the initial configuration of the class.
        #  
        # :bracketwise_lookup : Instead of looking up an object by LoaderBearingClass.loader_pattern_registry_lookup(:keyword)
        #                       you can simply use LoaderBearingClass[:keyword]
        #
        # :warn_on_key_changes : Warns whenever the registry overwrites an existing key.  Useful for debugging, sometimes.
        #
        # Some configuration directives are given as hashes.  Multiple directives may be combined into
        # a single hash.
        #
        # {:key => <METHOD_SYM>}  :  The method for asking the object what name it should be lookupable under.
        #
        # {:verbose => (true|false)} : How noisy do you want the loading to be?
        # 
        # {:style => :eval}
        #
        # {:style => :instance_exec}
        #
        # {:style => <PROC>}
        
        def loader_pattern_configure( *args )
          for arg in args
            case arg
            when :bracketwise_lookup
              self.extend( Features::BracketwiseLookup )
            when :warn_on_key_changes
              @loader_pattern_warn_on_key_changes = true
            when :dont_warn_on_key_changes
              @loader_pattern_warn_on_key_changes = false
            when Hash
              for key, val in arg
                case key
                when :key
                  self.class_eval do
                    eval( "alias :loader_pattern_registry_key #{val.to_sym.inspect}" )
                  end
                when :verbose
                  self.loader_pattern_verbose( val )
                when :style
                  case val     # styles allowed: :eval, :instance_exec
                  when :eval
                    self.extend( LoadingStyles::Eval )
                  when :instance_exec
                    self.extend( LoadingStyles::InstanceExec )
                  when :yaml
                    self.extend( LoadingStyles::YAML )
                    self.loader_pattern_extension( [:yml, :yaml] )
                  when Module
                    self.extend( val )
                  else
                    raise "Unknown Loader loading style: #{val.inspect}"
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
