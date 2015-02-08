module FunWith
  module Patterns
    module Loader
      
      # To simplify installing the loader pattern, loader_pattern_configure() is now going to be
      # callable on all objects by default, and will include FunWith::Patterns::Loader
      module ObjectAPI
        def loader_pattern_configure( *args )
          include FunWith::Patterns::Loader
          
          # hoping (vainly) that when the include finishes, loader_pattern_configure() is now a different method
          loader_pattern_configure( *args )
        end
      end
    end
  end
end