module FunWith
  module Patterns
    module Loader
      module LoadingStyles
        module Eval
          # Default behavior: read the file, evaluate it, expect a ruby object
          # of the class that the loader pattern is installed on.  If anything goes
          # wrong (file no exist, syntax error), returns a nil.
          #
          # Override in your class if you need your files translated
          # into objects differently.
          def loader_pattern_load_item( file )
            self.loader_pattern_rescue_failing_item_load( file ) do
              obj = eval( file.read )
          
              return obj
            end
          end
        end
      end
    end
  end
end