module FunWith
  module Patterns
    module GetAndSetAPI
      def activate( classes_to_activate = [Class, Module] )
        classes_to_activate = [classes_to_activate] unless classes_to_activate.is_a?(Array)
        
        for klass in classes_to_activate
          klass.send( :include, FunWith::Patterns::GetAndSet )
        end
      end
    end
  end
end