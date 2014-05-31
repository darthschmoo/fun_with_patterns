require 'fun_with_gems'

FunWith::Gems.make_gem_fun( "FunWith::Patterns" )

Class.send( :include, FunWith::Patterns::MakeInstancesReloadable )
Module.send( :include, FunWith::Patterns::MakeInstancesReloadable )
FunWith::Patterns::Reloadable.extend( FunWith::Patterns::ClassReloaderMethod )

# Activate Object#get_and_set / Module#get_and_set by calling GetAndSet.activate
FunWith::Patterns::GetAndSet.extend( FunWith::Patterns::GetAndSetAPI )