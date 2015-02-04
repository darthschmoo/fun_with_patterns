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
      
      # the name() method can be called with a block (to change the block that is to be executed)
      # or called with args to get the results of the block.  Uses the internal object variable @name
      def get_and_set_block( name, *args, &block )
        eval "define_method( :#{name} ) do |*args, &block|
                if block.is_a?( Proc )   # oddly, block_given? always returns false when defined this way
                  raise ArgumentError.new( 'Call #{name}() with either a block or args' ) unless args.length == 0
                  self.instance_variable_set( :@#{name}, block )
                  block
                else
                  block = self.instance_variable_get( :@#{name} )
                  ( block || Proc.new{} ).call( *args )
                end
              end "
      end
    end
  end
end