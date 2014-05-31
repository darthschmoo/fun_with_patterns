module FunWith
  module Patterns
    module GetAndSet
      def get_and_set( *method_names )
        for name in method_names
          if self.is_a?(Class) || self.is_a?(Module)
            eval "define_method( :#{name} ) do |*args|
                    self.instance_variable_set( :@#{name}, args.first ) if args.length == 1
                    self.instance_variable_get( :@#{name} )
                  end"
          else
            m = Module.new
            m.get_and_set( *method_names )
            self.extend( m )
          end
        end
      end
      
      # Would also like to do a boolean version which creates
      # .bool? .bool! and .not_bool!  
      
      def get_and_set_boolean( *method_names )
        for name in method_names
          if self.is_a?(Class) || self.is_a?(Module)
            eval "define_method( :#{name}? ) do
                    self.instance_variable_get( :@#{name} ) || false
                  end
          
                  define_method( :not_#{name}? ) do
                    ! self.#{name}?
                  end
          
                  define_method( :#{name}! ) do
                    self.instance_variable_set( :@#{name}, true )
                  end

                  define_method( :not_#{name}! ) do
                    self.instance_variable_set( :@#{name}, false )
                  end
  "
          else
            m = Module.new
            m.get_and_set_bool( *method_names )
            self.extend( m )
          end
        end
      end
    end
  end
end