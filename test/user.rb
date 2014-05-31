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