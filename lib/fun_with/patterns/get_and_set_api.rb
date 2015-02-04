module FunWith
  module Patterns
    module GetAndSetAPI
      # Can pass in an array listing the classes to activate, or just pass in arguments
      def activate( *classes_to_activate )
        if classes_to_activate.length == 1 && classes_to_activate.first.is_a?(Array)
          classes_to_activate = classes_to_activate.first
        elsif classes_to_activate.length == 0
          classes_to_activate = [Class, Module]   # no arguments given
        end
                
        for klass in classes_to_activate
          if klass == Class || klass == Module
            klass.send( :include, GetAndSet )    # Because individual classes or modules are objects of class Class/Module
          end
          
          klass.send( :extend, GetAndSet )
        end
      end
    end
  end
end