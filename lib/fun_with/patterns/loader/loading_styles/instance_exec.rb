module FunWith
  module Patterns
    module Loader
      module LoadingStyles
        # Assumes the class does not take arguments in its initialize() method.
        # The contents of the file are run via instance_exec to configure the object.
        module InstanceExec
          def loader_pattern_load_item( file )
            self.loader_pattern_rescue_failing_item_load( file ) do
              obj = self.new
              
              # obj.instance_eval( file.read )
              obj.instance_exec do
                eval( file.read )
              end
                            
              return obj
            end
          end
        end
      end
    end
  end
end