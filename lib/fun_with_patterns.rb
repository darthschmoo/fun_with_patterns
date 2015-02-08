require 'fun_with_gems'

FunWith::Gems.make_gem_fun( "FunWith::Patterns" )


# Activate Object#get_and_set / Module#get_and_set by calling GetAndSet.activate
FunWith::Patterns::GetAndSet.extend( FunWith::Patterns::GetAndSetAPI )
Object.send( :include, FunWith::Patterns::Loader::ObjectAPI )

