module FunWith
  module Patterns
    module Loader
      module LoadingStyles
        module YAML
          def loader_pattern_load_item( file )
            self.loader_pattern_rescue_failing_item_load( file ) do
              obj = self.new
              
              hash = Psych.load( file.read )
              
              for method, val in hash
                eq_method = :"#{method}="
                
                if obj.respond_to?( eq_method )
                  obj.send( eq_method, val )
                end
              end
              
              return obj
            end
          end
        end
      end
    end
  end
end
