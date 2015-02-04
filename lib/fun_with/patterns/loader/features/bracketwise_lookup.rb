module FunWith
  module Patterns
    module Loader
      module Features
        module BracketwiseLookup
          def []( key )
            loader_pattern_registry_lookup( key )
          end
          
          def []=( key, val )
            loader_pattern_register_item( val, key )
          end
        end
      end
    end
  end
end