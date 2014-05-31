warn( "Something wrong with the  Reloadable class.  Flaky.  Not recommended for use." )
module FunWith
  module Patterns
    # A bare-bones reloading system.  Useful when the entire file defines exactly one
    # class or module, with no dependencies or side-effects.
    module Reloadable
      def reload!
        FunWith::Patterns::Reloadable.reload_class( self )
      end
      
      def reloader_filepath
        @reloader_filepath
      end
    end
    
    module MakeInstancesReloadable
      def reloadable!
        self.extend( FunWith::Patterns::Reloadable )
        kaller = caller.first.gsub(/:\d+:in.*/, '')
        @reloader_filepath = kaller.fwf_filepath.expand
      end
    end
    
    module ClassReloaderMethod
      def reload_class( klass )
        if file = klass.reloader_filepath
          Object.send( :remove_const, klass.name.to_sym )
          file.load
        end
      end
    end
  end
end