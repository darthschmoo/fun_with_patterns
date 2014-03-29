require 'fun_with_gems'

FunWith::Gems.make_gem_fun( "FunWith::Patterns" )

Class.send( :include, FunWith::Patterns::MakeInstancesReloadable )
Module.send( :include, FunWith::Patterns::MakeInstancesReloadable )
FunWith::Patterns::Reloadable.extend( FunWith::Patterns::ClassReloaderMethod )