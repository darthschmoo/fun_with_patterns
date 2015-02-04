class User
  include FunWith::Patterns::Loader

  attr_accessor :name, :age
  
  def initialize( name, age )
    @name = name
    @age = age
  end
  
  # For User, name will be used to look up the item in the registry.
  alias :loader_pattern_registry_key :name
end

class User2
  attr_accessor :name, :age

  include FunWith::Patterns::Loader
  loader_pattern_configure( :bracketwise_lookup, {:key => :name} )
  
  def initialize( name, age )
    @name = name
    @age = age
  end
end

class User3
  FunWith::Patterns::GetAndSet.activate( self )
  
  get_and_set :name, :age
  
  include FunWith::Patterns::Loader
  loader_pattern_configure( :bracketwise_lookup, 
                            { :key => :name },
                            { :style => :instance_exec }   # Create object, run code in configuration file inside the object's context.
                          )
                          
end

class User4
  attr_accessor :name, :age
  
  include FunWith::Patterns::Loader
  loader_pattern_configure( :bracketwise_lookup, 
                            { :key => :name }, 
                            { :style => :yaml }
                          )
end
  